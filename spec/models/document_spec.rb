require 'rails_helper'

describe Document do
  context '#review_for_state' do
    it "gets the first review that matches the proposals state" do
      document = create(:document, state: 1)
      r1 = document.reviews.create(proposal_state: 1)
      r2 = document.reviews.create(proposal_state: 2)
      expect(document.review_for_state).to eq(r1)
    end

    it "creates a review item if no review exists for state" do
      document = create(:document, state: 1)
      document.reviews.create(proposal_state: 2)
      expect { document.review_for_state }.to change{Review.count}.by(1)
    end
  end

  context 'sending out emails after state transitions' do
    it 'doesnt send an email if the document is not finalized' do
      document = create(:document, state: 0)
      expect(document).to_not receive(:notify_broker_of_finalized_proposal)

      document.reviewed!
    end

    it 'sends an email when the document is finalized' do
      document = create(:document, state: 0)
      expect(document).to receive(:notify_broker_of_finalized_proposal)

      document.finalized!
    end
  end

  it '#due_date' do
    document = create(:document)
    expect(document.due_date).to eql(document.created_at + 24.hours)
  end
end
