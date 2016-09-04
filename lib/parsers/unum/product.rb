class Unum < Parser
  class Product < Parser
    attr_reader :parent, :class_selector

    def initialize(html, parent: parent, class_selector: class_selector)
      @parent = parent
      @class_selector = class_selector

      super(nil, html)
    end

    define_selector :title, "Title", :value do
      node = html.css("h2.#{class_selector}")[0]
      Attribute.new(node.text, node.css_path)
    end

    def product_classes
      [ProductClass.new(html, parent: self)]
    end
  end

  ##########################################
  ### Life
  ##########################################
  class LifeProduct < Product
    define_selector :title, "Title", :value do
      node = html.css("h2.#{class_selector}:contains('Life Insurance')")[0]
      Attribute.new(node.text, node.css_path)
    end

    def product_classes
      [Life.new(html, parent: self, class_selector: class_selector)]
    end
  end

  ##########################################
  ### AD&D
  ##########################################
  class ADDProduct < Product
    define_selector :title, "Title", :value do
      node = html.css("h2.#{class_selector}:contains('AD&D Insurance')")[0]
      Attribute.new(node.text, node.css_path)
    end

    define_selector :air_bag_benefit, "Air Bag Benefit", :table do
      node = html.css("tr.#{class_selector}:contains('Seat Belt and Airbag Benefit'):first")[0]
      Attribute.new(nil, node.css_path)
    end

    define_selector :seatbelt_benefit, "Seatbelt Benefit", :table do
      air_bag_benefit
    end

    define_selector :repatriation, "Repatiration", :table do
      node = html.css("tr.#{class_selector}:contains('Repatriation Benefit'):first")[0]
      Attribute.new(nil, node.css_path)
    end

    define_selector :value_added_services, "Value Added Services", :table do
      services = html.css("h2.#{class_selector}:contains('Included in Quote') ~ ul:first")
      Attribute.new(nil, services.first.css_path)
    end

    def product_classes
      [ADD.new(html, parent: self, class_selector: class_selector)]
    end
  end

  ##########################################
  ### Optional AD&D
  ##########################################
  class LifestyleADDProduct < Product
  end

  class LifestyleLifeProduct < Product
  end

  ##########################################
  ### STD
  ##########################################
  class STDProduct < Product
    def product_classes
      [STD.new(html, parent: self, class_selector: class_selector)]
    end
  end

  ##########################################
  ### LTD
  ##########################################
  class LTDProduct < Product
    def product_classes
      [LTD.new(html, parent: self, class_selector: class_selector)]
    end
  end
end
