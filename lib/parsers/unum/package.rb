class Unum < Parser
  class Package < Parser
    attr_reader :parent, :class_selector
    attr_accessor :products

    def initialize(html, parent: parent, class_selector: class_selector)
      @parent = parent
      @class_selector = class_selector

      super(nil, html)
    end

    define_selector :title, "Title", :value do
      node = html.css("h1 > a.#{class_selector}:first, p > a.#{class_selector}:first")[0]
      node = node.parent.next if node.text.include?("Benefits & Cost")
      Attribute.new(node.text, node.css_path)
    end

    define_selector :eligibility, "Eligibility", :value do
      node = html.css("h3.#{class_selector}:contains('Number of Eligible Employees')")[0].previous_sibling
      Attribute.new(node.text, node.css_path)
    end

    define_selector :waiting_period, "Waiting Period", :value do
      Attribute.new(nil, nil)
    end

    def products
      case title.value
      when /Short Term Disability/
        [STDProduct.new(html, parent: self, class_selector: class_selector)]
      when /Long Term Disability/
        [LTDProduct.new(html, parent: self, class_selector: class_selector)]
      when /Lifestyle/
        # LifeStyleParser
        []
      when /Life and Accidental Death/
        {'Life Insurance' => LifeProduct, 'AD&D Insurance' => ADDProduct}.map do |product_heading, product_klass|
          product = html.css("h2.#{class_selector}:contains('#{product_heading}')")

          product_klass.new(html, parent: self, class_selector: class_selector) if product.present?
        end.compact
        # [ADDProduct.new(html, parent: self), EmployeeLife.new(html, parent: self)]
      else
        []
        # whoops
      end
    end
  end
end
