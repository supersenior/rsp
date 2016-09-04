require 'rails_helper'

describe Admin::SourcesController do
  let(:user) { create(:user, :api) }
  before(:each) do
    allow_any_instance_of(Admin::SourcesController).to receive(:true_user).and_return(user)
  end

  describe 'GET #show' do
    it 'should load source' do
      source = create(:source)
      get :show, id: source.id
      expect(assigns[:source]).to eql(source)
    end
  end

  describe 'POST #create' do
    it 'should create source to document' do
      document = create(:document)
      expect {
        post :create, document_id: document.id, source: {file: fixture_file_upload('armoloy.html')}
      }.to change(Source, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    it 'should update source' do
      source = create(:source)
      patch :update, id: source.id, raw_html: 'test.html', format: :json
      source.reload
      expect(source.raw_html).to eql('test.html')
    end
  end
end
