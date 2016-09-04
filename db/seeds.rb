# create user
user = User.create email: 'user@polymathic.me', password: 'password', password_confirmation: 'password'

# create product types
["Short Term Disability", "Basic Life and AD&D", "Basic Dep Life", "Optional Life", "Optional AD&D", "LTD", "Advice To Pay"].each do |type|
  ProductType.create(name: type)
end

# create categories
["General Information", "Schedule of Benefits", "Schedule of Benefits - Employee Optional", "Schedule of Benefits - ATP per clm", "Schedule of Benefits - Employee VAD&D", "Schedule of Benefits - ATP clm recomm + bft calc", "Schedule of Benefits - ATP clm recomm only", "Schedule of Benefits - ATP clm recomm + check", "Schedule of Benefits - Spouse VAD&D", "Schedule of Benefits - Spouse Optional", "Schedule of Benefits - Child Optional", "Schedule of Benefits - Child VAD&D", "Financial", "Provisions", "AD&D Riders", "Riders", "Limitations/Exclusions", "Value Added Services"].each_with_index do |category_name, index|
  Category.create! name: category_name, category_order: index
end

broker_commission_attr = DynamicAttribute.create! display_name: 'Broker Commission',
                                                  parent_class: 'ProductClass',
                                                  value_type: 'DynamicValueString',
                                                  required: true,
                                                  category_id: 1,
                                                  attribute_order: 1

carrier = Carrier.create! name: "Sun Life Financial"
Carrier.create! name: "Unum"
carrier_two = Carrier.create! name: "MetLife"
employer = Employer.create! name: "OSA International, Inc."
project = Project.create! employer: employer,
                          name: "Test Project",
                          user: user,
                          effective_date: 1.year.from_now
proposal = project.proposals.create! carrier: carrier

source1 = proposal.sources.create! raw_html: File.read(Rails.root.to_s + "/spec/fixtures/SunLifeProposal.html")

product = proposal.products.create! product_type: ProductType.first
product_class = product.product_classes.create! class_number: 1

broker_commission_value = DynamicValueString.create! dynamic_attribute: broker_commission_attr,
                                                     parent: product_class,
                                                     value: '85%'
admin = User.create email: 'test@test.com', password: 'password'
admin.add_role(:admin)
