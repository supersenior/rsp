require 'pdf2html'
require 'nokogiri'

class Parser
  attr_reader :html
  Attribute = Struct.new(:value, :selector, :precision)

  def self.prepare_html(html)
    add_tbody_elements(html)
  end

  # Defines a selector method by creating a private function and wrapping
  # a call to that in error handling
  def self.define_selector(key, display_name, precision, &block)
    private_name = "_#{key.to_s}".to_sym
    define_method("_#{key.to_s}", &block)
    private private_name

    define_method(key) do
      begin
        send(private_name)
      rescue => e
        Rails.logger.error("Parser (#{self.class.name}) failed for attribute #{key}")
        Attribute.new
      end
    end
    self.selectors << {key: key, name: display_name, precision: precision}
  end

  def self.selectors
    @selectors ||= []
  end

  def initialize(filepath, data=nil)
    html = File.read(filepath) if filepath
    html = data if data

    if html.kind_of?(String)
      @html = Nokogiri::HTML(html)
    else
      @html = html
    end

    Parser.prepare_html(@html)
  end

  def to_obj(klass)
    keys = klass.new.attributes.keys
    hsh = {selectors: {}}
    keys.each do |k|
      if self.respond_to?(k)
        result = self.send(k)
        hsh[k] = result.value
        hsh[:selectors][k] = {display_name: k.to_s.humanize.titleize, query: result.selector}
      end
    end
    klass.new(hsh)
  end

  def to_db_obj
    return nil if !self.respond_to?(:packages)
    packages.map do |pkg|
      products = pkg.products.map do |product|
        product_classes = product.product_classes.map do |pc|
          pc.to_obj(ProductClass)
        end
        p = product.to_obj(Product)
        p.product_classes = product_classes
        p
      end
      package = pkg.to_obj(Package)
      package.products = products
      package
    end
  end

private

  def set_package_classes(packages)
    return if packages.length == 0
    cur_package = nil
    traverse(html.css('body')[0]) do |n|
      i = packages.index { |x| x== n }
      cur_package = i if i
      n['class'] = (n['class'] || "") << " package_#{cur_package}" if cur_package
    end
  end

  def traverse node, &block
    block.call(node)
    node.children.each{ |j| traverse(j, &block) }
  end

  def self.add_tbody_elements(html)
    html.xpath('//table').each do |htable|
      next if htable.css("tbody").count > 0
      tbody = html.create_element('tbody')
      tbody.children = htable.children
      htable.children = tbody
    end
  end

  def self.add_key(key)
    define_method(key) { public_send(key) }
  end
end

# require all of our parsers
Dir["./lib/parsers/*.rb"].each{|file| require(file) }
