require 'rails_helper'

describe Carrier do
  let(:carrier) { create(:carrier) }

  context '#parser' do
    it 'should return correct parser' do
      expect(carrier.parser).to eql(Metlife)
    end
  end

  context '#proposals' do
    it 'should return only proposals' do
      create(:document, carrier: carrier)
      create(:document, :policy, carrier: carrier)
      expect(carrier.documents.count).to eql(2)
      expect(carrier.proposals.count).to eql(1)
    end
  end

  context '#average_review_time' do
    it 'should return 0 when no documents' do
      expect(carrier.average_review_time).to eql(0)
    end

    it 'should return average time' do
      doc1 = create(:document, carrier: carrier)
      doc2 = create(:document, carrier: carrier)
      review1 = create(:review, document: doc1)
      review2 = create(:review, document: doc2)
      create(:review_item, review: review1, time: 2)
      create(:review_item, review: review2, time: 5)
      expect(carrier.average_review_time).to eql(3.5)
    end
  end
end