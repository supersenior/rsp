class DynamicValueAgeBand < DynamicValue
  serialize :value, Hash

  def value
    if read_attribute(:value).nil?
      write_attribute(:value, {})
    end
    read_attribute(:value)
  end

  def update(value_hash)
    if value_hash[:value]
      self.value ||= {}
      self.value.merge!(value_hash.delete(:value))
    end
    super(value_hash)
  end

  def composite
    self.value.try(:[], "composite")
  end

  def composite=(val)
    self.value["composite"] = val
  end

  def rate_value
    composite.extract_float if is_rate? && composite
  end

  def self.serialized_attr_accessor(*args)
    args.each do |method_name|
      (@age_band_keys ||= []) << method_name

      define_method(method_name) do
        (self.value || {})[method_name]
      end

      define_method("#{method_name}=") do |arg|
        self.value ||= {}
        self.value[method_name] = arg
      end
    end
  end

  def self.age_band_keys
    @age_band_keys || []
  end

  serialized_attr_accessor :age_0_19, :age_20_24, :age_25_29, :age_30_34, :age_35_39, :age_40_44, :age_45_49, :age_50_54, :age_55_59, :age_60_64, :age_65_69, :age_70_74, :age_75_79, :age_80_plus
end
