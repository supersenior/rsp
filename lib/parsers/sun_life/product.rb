class Sunlife < Parser
  class Product < Parser
    attr_reader :parent
    attr_accessor :classes

    def initialize(html, parent: parent)
      @parent = parent

      super(html)
    end

    def title
      parent.html.css('div').find{|par| par.text.match(/Eligible employees/) }
    end

    def classes
      return @classes if @classes

      indexes = []

      html.css('div').each_with_index do |par, index|
        indexes << index if par.text.match(/Class \d+/)
      end

      @classes = indexes.map{|index| html.css('div')[index] }
    end

    def broker_commission
      parent.html.css('div').
                  map{|par| par.text }.
                  find{|text| text.match(/Sun Life\Ws Life (.+) Scale broker commission/) }.
                  match(/Sun Life\Ws Life (.+) Scale broker commission/)[1]
    end

    def waiting_period
      waiting_period_index = html.css('div').find_index{|par| par.text.match(/Employee Basic Life, AD&D, and Dependent Life plan design/) }
      waiting_period_clause = html.css('div')[64].css("~ div").find{|par| par.text.match(/Class \d/) }.text
      waiting_period_list = waiting_period_clause.split(/\n/) # array of strings
      waiting_period_item = waiting_period_list.find{|item| item.match(/Waiting Period/) } # string

      waiting_period_item.match(/Waiting Period (.+)/)[1]
    end

    def benefit_calculation
      package_index = html.css('div').find_index{|par| par.text.match(/Employee Basic Life, AD&D, and Dependent Life plan design/) }
      package_period_clause = html.css('div')[64].css("~ div").find{|par| par.text.match(/Class \d/) }.text
      package_table = package_period_clause.split(/\n/) # array of strings
      # THERE MAY BE MULTIPLE PACKAGES!
      benefit = package_table.find{|item| item.match(/Benefit amount/) }

      benefit.match(/Benefit amount (\w+)/)[1]
    end

    def benefit_amount
      package_index = html.css('div').find_index{|par| par.text.match(/Employee Basic Life, AD&D, and Dependent Life plan design/) }
      package_period_clause = html.css('div')[64].css("~ div").find{|par| par.text.match(/Class \d/) }.text
      package_table = package_period_clause.split(/\n/) # array of strings
      # THERE MAY BE MULTIPLE PACKAGES!
      benefit = package_table.find{|item| item.match(/Benefit amount/) }

      benefit.match(/Benefit amount #{benefit_calculation}\s(\$.+)/)[1]
    end
  end
end
