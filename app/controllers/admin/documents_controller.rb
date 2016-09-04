class Admin::DocumentsController < AdminController
  include Reviewable
  include HasDynamicAttributes

  before_filter :load_project, only: [:create]
  before_filter :load_document, only: [:show, :update, :html_preview, :data_entry_finished, :review_finished]

  def show
    @carrier = @document.carrier
  end

  def create
    @document = @project.documents.create(document_params)

    if @document.valid?
      flash[:notice] = "Document uploaded."
      redirect_to admin_document_path(@document)
    else
      flash[:error] = @document.errors.full_messages.join(". ")
      redirect_to admin_project_path(@document)
    end
  end

  def update
    @document.update(document_params)
    respond_to do |format|
      format.html { render action: :show}
      format.json { head :ok }
    end
  end

  private

  def document_params
    p = params.require(:document).permit(:sic_code, :effective_date, :proposal_duration, :carrier_id, :state, :contributory)
    p[:effective_date] = Date.strptime(p[:effective_date], "%m/%d/%Y") if p[:effective_date]
    p
  end

  def load_document
    @document = Document.includes(products: :product_classes).find_by(id: params.require(:id))
  end

  def load_project
    @project = Project.find(params.require(:project_id))
  end
end
