require 'rails_helper'

describe Product do
  let(:product) { create(:product) }

  it 'should return unrecognized type always' do
    expect(product.title).to eql('Unrecognized Type')
  end
end
