class DynamicAttribute < ActiveRecord::Base
  has_and_belongs_to_many :product_types
  belongs_to :category
  has_many :dynamic_values, dependent: :delete_all
  has_many :orderings, as: :parent

  serialize :export_configuration, ExportConfiguration

  FINANCIAL_ATTRIBUTES = [
    'Rate Guarantee',
    'Basic Dependent Life Rate',
    'Basic AD&D Rate',
    'Basic Life Rate',
    'Long Term Disability Rate',
    'Child Opt AD&D Rate',
    'Employee Opt AD&D Rate',
    'Spouse Opt AD&D Rate',
    'Child Opt Life Rate',
    'Employee Opt Life Rate',
    'Spouse Opt Life Rate',
    'Short Term Disability Rate',
    'Advice to Pay + FMLA Rate (combined)',
    'Advice to Pay - Per Claim Fee',
    'Advice to Pay Rate - Check Cutting',
    'Advice to Pay Rate - Recommendation Only',
    'FMLA Rate'
  ]

  def value_class
    value_type.constantize
  end

  def export_styles
    styles = export_configuration.options.except(:format)
    styles[:format_code] ||= ExportConfiguration::DEFAULT_FORMAT_CODES[:float] if is_rate?
    styles.compact
  end
end
