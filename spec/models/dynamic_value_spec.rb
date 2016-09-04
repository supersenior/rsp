require 'rails_helper'

describe DynamicValue, '#discrepency=' do
  let(:value) { DynamicValue.new }

  it 'changes the comparison_flag to equivalent when passed "neutral"' do
    expect {
      value.discrepency = 'neutral'
    }.to change(value, :comparison_flag).from('not_compared').to('equivalent')
  end

  it 'changes the comparison_flag to better when passed "positive"' do
    expect {
      value.discrepency = 'positive'
    }.to change(value, :comparison_flag).from('not_compared').to('better')
  end

  it 'changes the comparison_flag to better when passed "negative"' do
    expect {
      value.discrepency = 'negative'
    }.to change(value, :comparison_flag).from('not_compared').to('worse')
  end

  it 'changes the comparison_flag from "worse" to "better"' do
    value.discrepency = 'negative'

    expect {
      value.discrepency = 'positive'
    }.to change(value, :comparison_flag).from('worse').to('better')
  end
end

describe DynamicValue, 'project' do
  it 'should return project based on parent type' do
    dynamic_value = create(:dynamic_value, :product_parent)
    expect(dynamic_value.parent).to be_an_instance_of(Product)
    expect(dynamic_value.project).to eql(dynamic_value.parent.document.project)

    dynamic_value = create(:dynamic_value, :project_product_type_parent)
    expect(dynamic_value.parent).to be_an_instance_of(ProjectProductType)
    expect(dynamic_value.project).to eql(dynamic_value.parent.project)

    dynamic_value = create(:dynamic_value, parent: nil)
    expect(dynamic_value.parent).to be_nil
    expect(dynamic_value.project).to be_nil
  end
end

describe DynamicValue, 'setting discrepency flags' do
  let(:policy) { create(:policy) }
  let(:dynamic_value) { create(:dynamic_value) }

  it 'should not check if the comparison flag has been changed manually' do
    expect(dynamic_value).to_not receive(:update_discrepency)

    dynamic_value.comparison_flag = :better

    dynamic_value.save
  end

  it 'should not set the discrepency if there is no policy' do
    project = instance_double 'Project', policies: []

    expect(dynamic_value).to receive(:project) { [project] }

    expect {
      dynamic_value.save
    }.to_not change(dynamic_value, :comparison_flag)
  end

  it 'should set the discrepency to neutral when the policy does not have a corresponding value' do
    dynamic_value.value = 'policy value'
    policy = instance_double 'Document'
    project = instance_double 'Project', policies: [policy]
    dynamic_attribute = instance_double 'DynamicAttribute', dynamic_values: double('ar association', includes: [])

    expect(dynamic_value).to receive(:dynamic_attribute) { dynamic_attribute }
    expect(dynamic_value).to receive(:project) { project }

    expect {
      dynamic_value.save
    }.to change(dynamic_value, :comparison_flag).from('not_compared').to('equivalent')
  end

  it 'should not set the discrepency if the value is the same as the policy value' do
    dynamic_value.value = 'policy value'
    policy = instance_double 'Document'
    project = instance_double 'Project', policies: [policy]
    policy_value = instance_double 'DynamicValue', document: policy, value: 'policy value'
    dynamic_attribute = instance_double 'DynamicAttribute', dynamic_values: double('ar association', includes: [policy_value])

    expect(dynamic_value).to receive(:dynamic_attribute) { dynamic_attribute }
    expect(dynamic_value).to receive(:project) { project }

    expect {
      dynamic_value.save
    }.to_not change(dynamic_value, :comparison_flag)
  end

  it 'should set the discrepency to neutral when the value differs from the policy' do
    dynamic_value.value = 'proposal value'
    policy = instance_double 'Document'
    project = instance_double 'Project', policies: [policy]
    policy_value = instance_double 'DynamicValue', document: policy, value: 'policy value'
    dynamic_attribute = instance_double 'DynamicAttribute', dynamic_values: double('ar association', includes: [policy_value])

    expect(dynamic_value).to receive(:dynamic_attribute) { dynamic_attribute }
    expect(dynamic_value).to receive(:project) { project }

    expect {
      dynamic_value.save
    }.to change(dynamic_value, :comparison_flag).from('not_compared').to('equivalent')
  end

  it 'should set the discrepency to neutral when the policy doesnt have a corresponding value' do
    policy = instance_double 'Document'
    project = instance_double 'Project', policies: [policy]
    dynamic_attribute = instance_double 'DynamicAttribute', dynamic_values: double('ar association', includes: [])

    expect(dynamic_value).to receive(:dynamic_attribute) { dynamic_attribute }
    expect(dynamic_value).to receive(:project) { project }

    expect {
      dynamic_value.save
    }.to change(dynamic_value, :comparison_flag).from('not_compared').to('equivalent')
  end

  it 'should set the discrepency to not_compared when the policy value is different than the proposal value' do
    dynamic_value.update(comparison_flag: 'equivalent')
    dynamic_value.value = 'policy value'

    policy = instance_double 'Document'
    project = instance_double 'Project', policies: [policy]
    policy_value = instance_double 'DynamicValue', document: policy, value: 'policy value'
    dynamic_attribute = instance_double 'DynamicAttribute', dynamic_values: double('ar association', includes: [policy_value])

    expect(dynamic_value).to receive(:dynamic_attribute) { dynamic_attribute }
    expect(dynamic_value).to receive(:project) { project }

    expect {
      dynamic_value.save
    }.to change(dynamic_value, :comparison_flag).from('equivalent').to("not_compared")
  end
end

describe DynamicValue, '#rate_value' do
  let(:dynamic_value) { DynamicValue.new value: '20.50' }

  it 'returns nil if it is not a rate' do
    allow(dynamic_value).to receive(:is_rate?) { false }

    expect(dynamic_value.rate_value).to eql(nil)
  end

  it 'returns nil if it is a rate but the value is nil' do
    dynamic_value.value = nil
    allow(dynamic_value).to receive(:is_rate?) { true }

    expect(dynamic_value.rate_value).to eql(nil)
  end

  it 'returns the float value if it is a rate' do
    allow(dynamic_value).to receive(:is_rate?) { true }

    expect(dynamic_value.rate_value).to eql(20.5)
  end
end

describe DynamicValueAgeBand do
  let(:dynamic_value) { create(:dynamic_value_age_band) }

  it 'should update hash value' do
    dynamic_value.update({value: {age_0_19: 2, age_20_24: 4}})
    expect(dynamic_value.age_0_19).to eql(2)
    expect(dynamic_value.age_20_24).to eql(4)
  end

  it 'should update age band value directly' do
    dynamic_value.age_0_19 = 2
    dynamic_value.save
    expect(dynamic_value.age_0_19).to eql(2)
  end

  it 'should get/set composite value' do
    expect(dynamic_value.composite).to be_nil
    dynamic_value.composite = 0.5
    dynamic_value.save
    expect(dynamic_value.composite).to eql(0.5)
  end

  it 'should return all age band keys' do
    expect(DynamicValueAgeBand.age_band_keys.count).to eql(14)
  end
end