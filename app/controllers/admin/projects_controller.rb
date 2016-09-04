class Admin::ProjectsController < AdminController
  before_filter :load_project, only: [:show, :update]

  def show
    @new_proposal = Document.new(project: @project)
  end

  private

  def load_project
    @project = Project.find(params.require(:id))
  end
end
