class Unum < Parser
  class ProductClass < Parser
    attr_reader :parent, :class_selector

    def initialize(html, parent: parent, class_selector: class_selector)
      @parent = parent
      @class_selector = class_selector

      super(nil, html)
    end

    define_selector :participating_employees, "Participating Employees", :value do
      Attribute.new(nil, nil)
    end

    define_selector :total_eligible_employees, "Total Eligible Employees", :sentence do
      node = html.css("h3.#{class_selector}:contains('Number of Eligible Employees')")[0]
      Attribute.new(node.text, node.css_path)
    end
    alias_method :eligible_employees, :total_eligible_employees

    define_selector :guarantee_issue, "Guarantee Issue", :value do
      Attribute.new
    end

    define_selector :employer_contribution, "Employer Contribution", :sentence do
      node = html.css("td.#{class_selector}:contains('Cost of Coverage Paid By')")[0]
      row = node.ancestors("tr")[0]
      val = node.next.text
      Attribute.new(val, row.css_path)
    end

    define_selector :participation_requirement, "Pariticpation Requirement", :sentence do
      employer_contribution
    end

    define_selector :contributions, "Contributions", :sentence do
      employer_contribution
    end

    define_selector :exclusions, "Exclusions", :paragraph do
      header = html.css("h1.#{class_selector}:contains('Coverage Exclusions:')")
      Attribute.new(nil, header[0].css_path)
    end
  end

  ##########################################
  ### Life
  ##########################################
  class Life < ProductClass
    define_selector :benefit_schedule, "Benefit Schedule", :sentence do
      node = html.css("td.#{class_selector}").detect { |x| x.text.match(/Employee Life Benefit Amount/) }
      row = node.ancestors("tr")[0]
      index = row.children.find_index { |x| x == node }
      val = row.next.children[index].text
      Attribute.new(val, row.css_path)
    end

    define_selector :rounding_rules, "Rounding Rules", :sentence do
      benefit_schedule
    end

    define_selector :benefit_maximum, "Benefit Maximum", :value do
      node = html.css("td.#{class_selector}").detect { |x| x.text.match(/Overall Maximum/) }
      row = node.ancestors("tr")[0]
      index = row.children.find_index { |x| x == node }
      val = row.next.children[index].text
      Attribute.new(val, row.css_path)
    end

    define_selector :benefit_minimum, "Benefit Minimum", :value do
      node = html.css("p.#{class_selector}:contains('Employee Life Minimum') ~ p:contains('$')")[0]
      Attribute.new(node.text, node.css_path)
    end

    define_selector :age_reduction_schedule, "Age Reduction Schedule", :paragraph do
      node = html.css("p.#{class_selector}:contains('Employee Life Benefit Reduction Formula')")[0]
      Attribute.new(nil, node.css_path)
    end

    def rates_table
      table = html.css("h2.#{class_selector}:contains('Life Rates') ~ table:first")
      guarantee = html.css("h3.#{class_selector}:contains('Rate Guarantee:')")

      table_path = table.first.css_path
      guarantee_path = guarantee.first.css_path

      volume    = Attribute.new nil, table_path
      rate      = Attribute.new nil, table_path
      basis     = Attribute.new nil, table_path
      premium   = Attribute.new nil, table_path
      guarantee = Attribute.new nil, guarantee_path

      OpenStruct.new volume: volume, rate: rate, basis: basis, premium: premium, guarantee: guarantee
    end


    define_selector :rate_basis, "Rate Basis", :table do
      rates_table.basis
    end

    define_selector :total_volume, "Total Volume", :table do
      rates_table.volume
    end

    define_selector :rate_guarantee, "Rate Guarantee", :sentence do
      rates_table.guarantee
    end

    define_selector :total_monthly_premium, "Total Monthly Premium", :table do
      rates_table.premium
    end

    define_selector :rate, "Rate", :table do
      rates_table.rate
    end

    define_selector :conversion, "Conversion", :value do
      node = html.css("td.#{class_selector}:contains('Life Insurance Conversion Privilege)").detect { |x| !x.next.nil? }
      row = node.ancestors("tr")[0]
      Attribute.new(node.next.text, row.css_path)
    end

    define_selector :waiver_of_premium, "Waiver of Premium", :value do
      node = html.css("td.#{class_selector}:contains('Life Insurance Premium Waiver')").detect { |x| !x.next.nil? }
      row = node.ancestors("tr")[0]
      Attribute.new(node.next.text, row.css_path, :value)
    end

    define_selector :portability, "Portability", :value do
      node = html.css("td.#{class_selector}:contains('Portability')").detect { |x| !x.next.nil? }
      row = node.ancestors("tr")[0]
      Attribute.new(node.next.text, row.css_path, :value)
    end
  end

  ##########################################
  ### AD&D
  ##########################################
  class ADD < ProductClass
    define_selector :child_tuition, "Child Tuition", :table do
      row = html.css("tr.#{class_selector}:contains('AD&D Education Benefit'):first")
      table = row[0].ancestors('table')[0]
      Attribute.new(nil, table.css_path)
    end

    define_selector :disappearance_benefit, "Disappearance Benefit", :table do
      row = html.css("p.#{class_selector}:contains('AD&D Exposure and Disappearance Benefit:')")[0].ancestors('tr')[0]
      Attribute.new(nil, row.css_path)
    end

    define_selector :paraplegia_benefit, "Paraplegia Benefit", :table do
      row = html.css("tr.#{class_selector}:contains('Paraplegia')")[0]
      Attribute.new(nil, row.css_path)
    end

    define_selector :exclusions, "Exclusions", :paragraph do
      header = html.css("h1.#{class_selector}:contains('Coverage Exclusions:')")
      header_path = header[0].css_path

      exclusion_li = header[0].ancestors('li').first
      list = exclusion_li.css('~ li')
      termination_index = list.css('li').find_index{|li| li.text.match(/Coverage Termination:/) }

      items = list[0..termination_index-1]
      exclusion_selectors = items.map{|item| item.css_path }.join(',')

      Attribute.new(nil, exclusion_selectors)
    end

    define_selector :benefit_schedule, "Benefit Schedule", :value do
      node = html.css("td.#{class_selector}").detect { |x| x.text.match(/Employee AD&D Benefit Amount/) }
      row = node.ancestors("tr")[0]
      index = row.children.find_index { |x| x == node }
      val = row.next.children[index].text

      Attribute.new(val, row.css_path)
    end

    define_selector :rounding_rules, "Rounding Rules", :value do
      benefit_schedule
    end

    define_selector :benefit_calculation, "Benefit Calculation", :value do
      benefit_schedule
    end

    define_selector :benefit_maximum, "Benefit Maximum", :value do
      node = html.css("td.#{class_selector}").detect { |x| x.text.match(/AD&D Maximum/) }
      row = node.ancestors("tr")[0]
      index = row.children.find_index { |x| x == node }
      val = row.next.children[index].text

      Attribute.new(val, row.css_path)
    end

    define_selector :benefit_maximum, "Benefit Minimum", :value do
      node = html.css("p.#{class_selector}:contains('Employee AD&D Minimum') ~ p:contains('$')")[0]
      Attribute.new(node.text, node.css_path)
    end

    define_selector :age_reduction_schedule, "Age Reduction Schedule", :paragraph do
      node = html.css("p.#{class_selector}:contains('Employee AD&D Benefit Reduction Formula')")[0]
      Attribute.new(nil, node.css_path)
    end

    def rates_table
      table = html.css("h2.#{class_selector}:contains('AD&D Rates') ~ table:first")
      guarantee = html.css("h3.#{class_selector}:contains('Rate Guarantee:')")

      table_path = table.first.css_path
      guarantee_path = guarantee.first.css_path

      volume    = Attribute.new nil, table_path
      rate      = Attribute.new nil, table_path
      basis     = Attribute.new nil, table_path
      premium   = Attribute.new nil, table_path
      guarantee = Attribute.new nil, guarantee_path

      OpenStruct.new volume: volume, rate: rate, basis: basis, premium: premium, guarantee: guarantee
    end

    define_selector :rate_basis, "Rate Basis", :table do
      rates_table.basis
    end

    define_selector :total_volume, "Total Volume", :table do
      rates_table.volume
    end

    define_selector :rate_guarantee, "Rate Guarantee", :sentence do
      rates_table.guarantee
    end

    define_selector :total_monthly_premium, "Total Monthly Premium", :table do
      rates_table.premium
    end

    define_selector :rate, "Rate", :table do
      rates_table.rate
    end

    define_selector :conversion, "Conversion", :value do
      node = html.css("td.#{class_selector}:contains('Life Insurance Conversion Privilege')").detect { |x| !x.next.nil? }
      row = row = node.ancestors("tr")[0]
      val = node.next.text
      Attribute.new(val, row.css_path)
    end

    define_selector :waiver_of_premium, "Waiver of Premium", :value do
      node = html.css("td.#{class_selector}:contains('Life Insurance Premium Waiver')").detect { |x| !x.next.nil? }
      row = row = node.ancestors("tr")[0]
      val = node.next.text
      Attribute.new(val, row.css_path)
    end

    define_selector :portability, "Portability", :value do
      node = html.css("td.#{class_selector}:contains('Portability')").detect { |x| !x.next.nil? }
      row = row = node.ancestors("tr")[0]
      val = node.next.text
      Attribute.new(val, row.css_path)
    end

    define_selector :accelerated_benefit, "Accelerated Benefit", :value do
      node = html.css("p.#{class_selector}:contains('Accelerated Benefit')")[0]
      val = node.text.split("Accelerated Benefit –")[1].gsub(/[^0-9a-z ,$%]/i, '').strip
      Attribute.new(val, node.css_path)
    end
    alias_method :accelerated_death_benefit, :accelerated_benefit
  end

  ##########################################
  ### General Disability
  ##########################################
  class Disability < ProductClass
    define_selector :benefit_schedule, "Benefit Schedule", :sentence do
      node = html.css("td.#{class_selector}").detect { |x| x.text.match(/Weekly Benefit/) || x.text.match(/Monthly Benefit/) }
      row = node.ancestors("tr")[0]
      Attribute.new(nil, row.css_path)
    end

    define_selector :benefit_maximum, "Benefit Maximum", :sentence do
      benefit_schedule
    end

    define_selector :benefit_minimum, "Benefit Minimum", :value do
      node = html.css("p.#{class_selector}:contains('Minimum Weekly Benefit')")[0]
      node ||= html.css("p.#{class_selector}:contains('Minimum Monthly Benefit')")[0]
      Attribute.new(node.text, node.css_path)
    end

    define_selector :guarantee_issue, "Guarantee Issue", :value do
      node = html.css("p.#{class_selector}:contains('Guaranteed Insurability')")[0]
      Attribute.new(node.text, node.css_path)
    end

    define_selector :elimination_period, "Elimination Period", :sentence do
      node = html.css("td.#{class_selector} > p:contains('Elimination Period')")[0].ancestors("td")[0]
      row = node.ancestors("tr")[0]
      content = node.next.text
      if content.blank?
        table = node.ancestors("table")[0]
        if table.next.name == "ul"
          return Attribute.new(nil, table.next.css_path)
        end
      end
      Attribute.new(content, row.css_path)
    end

    define_selector :benefit_duration, "Benefit Duration", :sentence do
      node = html.css("td.#{class_selector}").detect { |x| x.text.match(/Benefit Duration/) }
      row = node.ancestors("tr")[0]
      index = row.children.find_index { |x| x == node }
      val = row.next.children[index].text
      Attribute.new(val, row.css_path)
    end

    define_selector :rehabilitation_incentive_benefit, "Rehabilitation Incentive Benefit", :sentence do
      node = html.css("td").detect { |x| x.text.match(/Rehabilitation and Return to Work/) }
      row = node.ancestors("tr")[0]
      val = node.next.text
      Attribute.new(val, row.css_path, :sentence)
    end

    def rates_table
      title = html.css("a.#{class_selector}:contains('Rates and Cost Information')")[0]
      title = title.ancestors("h1, p")[0]
      table = html.css(title.css_path + " ~ table:first")
      guarantee = html.css("h3.#{class_selector}:contains('Rate Guarantee:')")
      if guarantee.count == 0
        guarantee = html.css("p.#{class_selector}:contains('Rate Guarantee:')")
      end

      table_path = table.first.css_path
      guarantee_path = guarantee.first.css_path

      volume    = Attribute.new nil, table_path
      rate      = Attribute.new nil, table_path
      basis     = Attribute.new nil, table_path
      premium   = Attribute.new nil, table_path
      guarantee = Attribute.new nil, guarantee_path

      OpenStruct.new volume: volume, rate: rate, basis: basis, premium: premium, guarantee: guarantee
    end

    define_selector :rate_basis, "Rate Basis", :table do
      rates_table.basis
    end

    define_selector :total_volume, "Total Volume", :table do
      rates_table.volume
    end

    define_selector :rate_guarantee, "Rate Guarantee", :sentence do
      rates_table.guarantee
    end

    define_selector :total_monthly_premium, "Total Monthly Premium", :table do
      rates_table.premium
    end

    define_selector :rate, "Rate", :table do
      rates_table.rate
    end
  end

  ##########################################
  ### STD
  ##########################################
  class STD < Disability
  end

  ##########################################
  ### LTD
  ##########################################
  class LTD < Disability
    define_selector :disability_definition, "Disability Definition", :sentence do
      node = html.css("td.#{class_selector}").detect { |x| x.text.match(/Definition of Disability/) }
      row = node.ancestors("tr")[0]
      Attribute.new(nil, row.css_path)
    end

    define_selector :own_occupation, "Own Occupation", :sentence do
      disability_definition
    end

    define_selector :survivor_benefit, "Survivor Benefit", :sentence do
      node = html.css("p.#{class_selector}:contains('Survivor Benefit')")[0]
      Attribute.new(nil, node.css_path)
    end

    define_selector :waiver_of_premium, "Waiver of Premium", :sentence do
      node = html.css("p.#{class_selector}:contains('Waiver of Premium')")[0]
      Attribute.new(nil, node.css_path)
    end

    define_selector :social_security_offsets, "Social Security Offsets", :sentence do
      node = html.css("td.#{class_selector}").detect { |x| x.text.match(/Social Security Integration/) }
      row = node.ancestors("tr")[0]
      val = node.next.text
      Attribute.new(val, row.css_path)
    end

    define_selector :pre_existing_conditions, "Pre Existing Conditions", :sentence do
      node = html.css("p.#{class_selector}:contains('Pre-Existing')")[0]
      Attribute.new(node.text, node.css_path)
    end

    def limitations_table
      table = html.css("h3.#{class_selector}:contains('Limitations:') ~ table")[0]
      Attribute.new(nil, table.css_path)
    end

    define_selector :self_reported_limitation, "Self Reported Limitation", :table do
      limitations_table
    end

    define_selector :mental_nervous_limitation, "Mental Nervous Limitation", :table do
      limitations_table
    end

    define_selector :zero_day_residual, "Zero Day Residual", :table do
      limitations_table
    end

    define_selector :trial_work_days, "Trial Work Days", :table do
      elimination_period
    end

    define_selector :reasonable_accommodation_benefit, "Reasonable Accommodation Benefit", :table do
      rehabilitation_incentive_benefit
    end

    define_selector :return_to_work_incentive, "Return To Work Incentive", :table do
      rehabilitation_incentive_benefit
    end
  end
end
