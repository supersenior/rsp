class SunLife < Parser
  class Package < Parser
    attr_reader :parent, :class_selector
    attr_accessor :products

    def initialize(html, parent: parent, class_selector: class_selector)
      @parent = parent
      @class_selector = class_selector

      super(nil, html)
    end

    define_selector :title, "Title", :value do
      node = html.css(".s2.#{class_selector}")[0]
      Attribute.new(node.text, node.css_path)
    end

    define_selector :eligibility, "Eligibility", :value do
      # node = html.css("h3.#{class_selector}:contains('Number of Eligible Employees')")[0].previous_sibling
      # Attribute.new(node.text, node.css_path)
    end

    define_selector :waiting_period, "Waiting Period", :value do
      Attribute.new(nil, nil)
    end

    def products
      []
      # product_titles = html.css(".s6.#{class_selector}").map(&:text)
      #
      # if product_titles.empty?
      #   node = html.css("p.#{class_selector}:contains('Plan design and rates')")[0].next
      #   while node.text.blank?
      #     node = node.next
      #   end
      #   product_titles= [node.text]
      # end
      #
      # product_titles.uniq
    end
  end
end
