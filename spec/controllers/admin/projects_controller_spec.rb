require 'rails_helper'

describe Admin::ProjectsController do
  let(:user) { create(:user, :api) }
  before(:each) do
    allow_any_instance_of(Admin::ProjectsController).to receive(:true_user).and_return(user)
  end

  describe 'GET #show' do
    it 'should load document and carrier' do
      project = create(:project)
      get :show, id: project.id
      expect(assigns[:project]).to eql(project)
      expect(assigns[:new_proposal]).to be_a_new(Document)
    end
  end
end
