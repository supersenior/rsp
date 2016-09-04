class Admin::SourcesController < AdminController
  before_filter :load_source, only: [:show]
  before_filter :load_document, only: [:create]

  def show
    # TODO: scope the finder to the current_user's
    #       accessibility of the project
    source = Source.find params[:id]

    respond_to do |format|
      format.html { render layout: false, text: source.raw_html }
    end
  end

  def create
    params = source_params
    if params[:file].present?
      params = { raw_html: read_file_from_upload(params[:file]) }
    end
    @source = @document.sources.create(params)

    if @source.valid?
      flash[:notice] = "Source uploaded."
      redirect_to admin_document_path(@document)
    else
      flash[:error] = @source.errors.full_messages.join(". ")
      redirect_to admin_document_path(@document)
    end
  rescue ActionController::ParameterMissing
    redirect_to admin_document_path(@document), notice: 'You must select a file to upload'
  end

  # we want to update the markup
  def update
    source = Source.find params[:id]

    if source.update(raw_html: params[:raw_html])
      respond_to do |format|
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.json { head :unprocessable_entity }
      end
    end
  end

  private

  def source_params
    params.require(:source).permit(:file)
  end

  def load_source
    @source = Source.find(params[:id])
  end

  def load_document
    @document = Document.find(params[:document_id])
  end

  def read_file_from_upload(file_data)
    if file_data.respond_to?(:read)
      return file_data.read
    elsif file_data.respond_to?(:path)
      return File.read(file_data.path)
    else
      logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      nil
    end
  end
end
