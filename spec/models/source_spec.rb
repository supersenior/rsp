require 'rails_helper'

RSpec.describe Source, :type => :model do
  context "validations" do
    it "is valid if content type is html" do
      expect(
        build(:source, file: File.new(Rails.root + 'spec/fixtures/armoloy.html'))
      ).to be_valid
    end

    describe "content type" do
      it "is not valid if content type is not html / pdf / word" do
        expect(
          build(:source, file: File.new(Rails.root + 'spec/fixtures/invalid_file.png'))
        ).to_not be_valid
      end
    end
  end
end
