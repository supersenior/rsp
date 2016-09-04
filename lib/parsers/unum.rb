require_relative './unum/package'
require_relative './unum/product'
require_relative './unum/product_class'

class Unum < Parser
  define_selector :carrier_name, "Carrier Name", :value do
    Attribute.new("Unum", nil)
  end

  define_selector :financial_ratings, "Financial Ratings", :value do
    Attribute.new(nil, nil)
  end

  define_selector :funding, "Funding", :value do
    Attribute.new(nil, nil)
  end

  define_selector :broker_commission, "Broker Commission", :value do
    Attribute.new(nil, nil)
  end

  define_selector :employer_name, "Employer Name", :value do
    node = html.css('td').detect { |x| x.text.match(/Prepared For/) }
    row = node.ancestors("tr")[0]
    val = node.next.text

    Attribute.new(val, row.css_path)
  end

  define_selector :sic_code, "SIC Code", :value do
    Attribute.new(nil, nil)
  end

  define_selector :effective_date, "Effective Date", :value do
    node = html.css('h3').detect { |x| x.text.match(/effective date/) }
    val = node.text.split(":")[1]
    val = Date.parse(val) if !val.blank?
    Attribute.new(val, node.css_path)
  end

  define_selector :proposal_duration, "Proposal Duration", :value do
    node = html.css('p:contains("Benefit Duration")')[0]
    val = node.ancestors("td")[0].next.text
    selector = node.ancestors("tr")[0].css_path

    Attribute.new(val, selector)
  end

  def packages
    @packages ||= begin
      nodes = html.css('h1:contains("Benefits & Cost Summary"), p:contains("Benefits & Cost Summary")').to_a
      nodes.shift # ignore the cover letter instance

      set_package_classes(nodes)

      nodes.each_with_index.map do |node, index|
        Package.new(html, class_selector: "package_#{index}")
      end
    end
  end
end
