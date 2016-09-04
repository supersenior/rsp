require 'rails_helper'

describe Project, type: :model do
  let(:project) { create(:project) }
  let(:proposal) { create(:document, project: project) }

  describe '#mark_as_sold' do
    it 'returns true when a proposal is updated as sold' do
      expect(proposal).to receive(:update) { true }

      expect(project.mark_as_sold(proposal)).to eql(true)
    end

    it 'returns false if the proposal is not updated as sold' do
      expect(proposal).to receive(:update) { false }

      expect(project.mark_as_sold(proposal)).to eql(false)
    end

    it 'returns false if a proposal is already marked as sold' do
      project.mark_as_sold(proposal)

      expect(project.mark_as_sold(proposal)).to eql(false)
    end
  end

  describe '#name' do
    it 'should update employer name' do
      project.name = 'Test Project'
      expect(project.employer.name).to eql('Test Project')
    end
  end
end
