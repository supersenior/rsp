require_relative './sun_life/package'
# require_relative './sunlife/product'
# require_relative './sunlife/product_class'

class SunLife < Parser
  define_selector :carrier_name, "Carrier Name", :value do
    Attribute.new("Sunlife", nil)
  end

  define_selector :financial_ratings, "Financial Ratings", :value do
    Attribute.new(nil, nil)
  end

  define_selector :funding, "Funding", :value do
    Attribute.new(nil, nil)
  end

  define_selector :employer_name, "Employer Name", :value do
    node = html.css('p:contains("Proposal presented to")')[0].next
    val = node.text.split(",").first

    Attribute.new(val, node.css_path)
  end

  define_selector :sic_code, "SIC Code", :value do
    node = html.css('p:contains("SIC Code:")')[0]
    val = node.text.split(":").last.strip

    Attribute.new(val, node.css_path)
  end

  define_selector :effective_date, "Effective Date", :value do
    node = html.css('p:contains("Proposed Effective Date")')[0].next
    val = Date.parse(node.text)

    Attribute.new(val, node.css_path)
  end

  define_selector :proposal_duration, "Proposal Duration", :value do
    Attribute.new(nil, nil)
  end

  def packages
    @packages ||= begin
      packages = []
      hits = html.css(".s2").to_a
      hits.each_with_index do |node, i|
        packages << hits[i - 1] if i > 0 && node.next && node.next.text.match(/Plan design and rates/)
      end

      set_package_classes(packages)

      packages.each_with_index.map do |node, index|
        Package.new(html, class_selector: "package_#{index}")
      end
    end
  end
end
