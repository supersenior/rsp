require 'rails_helper'

describe Admin::DocumentsController do
  let(:user) { create(:user, :api) }
  before(:each) do
    allow_any_instance_of(Admin::DocumentsController).to receive(:true_user).and_return(user)
  end

  describe 'GET #show' do
    it 'should load document and carrier' do
      document = create(:document)
      get :show, id: document.id
      expect(assigns[:document]).to eql(document)
      expect(assigns[:carrier]).to eql(document.carrier)
    end
  end

  describe 'POST #create' do
    it 'should create document to project' do
      project = create(:project)
      carrier = create(:carrier)
      expect {
        post :create, project_id: project.id, document: {carrier_id: carrier.id}
      }.to change(Document, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    it 'should update document' do
      document = create(:document)
      patch :update, id: document.id, document: { state: :needs_review }
      document.reload
      expect(document.state).to eql('needs_review')
    end
  end
end
