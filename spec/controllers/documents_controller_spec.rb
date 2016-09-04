require 'rails_helper'

RSpec.describe DocumentsController, :type => :controller do

  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  before(:each) do
    allow_any_instance_of(DocumentsController).to receive(:current_user).and_return(user)
  end

  describe "POST create" do
    context "document creation" do
      it "creates a new document if one does not exist" do
        expect {
          post :create, project_id: project.id, file: [], document: {document_type: "Proposal"}
        }.to change(Document, :count).by(1)
      end
    end

    context "creates sources if files are attached" do
      it "adds a source for each file attached" do
        file1 = fixture_file_upload('armoloy.html', 'text/html')
        file2 = fixture_file_upload('osa.html', 'text/html')
        expect {
          post :create, project_id: project.id, file: [file1, file2], document: {document_type: "Proposal"}
        }.to change(Source, :count).by(2)
      end

      it "returns a 422 if file upload fails" do
        file = fixture_file_upload('invalid_file.png', 'image/png') # <- Invalid
        post :create, project_id: project.id, file: {"0" => file}, document: {document_type: "Proposal"}
        expect(response.status).to eq(422)
      end

      it "rolls back all database changes if one file upload fails" do
        file1 = fixture_file_upload('armoloy.html', 'text/html')
        file2 = fixture_file_upload('invalid_file.png', 'image/png') # <- Invalid
        expect {
          post :create, project_id: project.id, file: { "0" => file1, "1" => file2 }, document: {document_type: "Proposal"}
        }.to change(Source, :count).by(0)
      end
    end
  end

  describe "POST #unarchive" do
    it 'should update document as unarchived' do
      document = create(:document, project: project, is_archived: true)
      expect {
        post :unarchive, project_id: project.id, id: document.id, format: :json
        document.reload
      }.to change(document, :is_archived).from(true).to(false)
    end
  end

  describe "DELETE #destroy" do
    it 'should archive document' do
      document = create(:document, project: project, is_archived: false)
      expect {
        delete :destroy, project_id: project.id, id: document.id, format: :json
        document.reload
      }.to change(document, :is_archived).from(false).to(true)
    end
  end
end
