require 'rails_helper'

describe DynamicValuesController do

  let(:user) { create(:user) }
  before(:each) do
    allow_any_instance_of(DynamicValuesController).to receive(:current_user).and_return(user)
  end

  describe "PATCH #update" do
    let(:dynamic_value) { create(:dynamic_value) }

    it 'should update with current user attributes' do
      expect {
        patch :update, id: dynamic_value.id, discrepency: 'better', format: :json
      }.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it 'should update comparison flag' do
      dynamic_value.parent.document.project.update(user_id: user.id)
      expect {
        patch :update, id: dynamic_value.id, discrepency: 'positive', format: :json
        dynamic_value.reload
      }.to change(dynamic_value, :comparison_flag).to('better')
    end
  end

end