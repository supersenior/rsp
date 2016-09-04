FactoryGirl.define do
  factory :document do
    project
    carrier
    document_type 'Proposal'

    trait(:policy) do
      document_type 'Policy'
    end

    trait(:finalized) do
      state :finalized
    end
  end
end
