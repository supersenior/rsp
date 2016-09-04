class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_filter :load_project
  before_filter :load_document, except: [:create]

  def create
    Document.transaction do
      @document = @project.documents.create(document_params)
      sources = sources_from_params
      if sources.all?(&:save)
        notify_admins_of_new_sources(@document)

        head :ok
      else
        render json: sources.map { |f| f.errors.full_messages }.flatten, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def unarchive
    @document.unarchive!

    head :ok
  end

  def destroy
    @document.archive!

    head :ok
  end

private

  def notify_admins_of_new_sources(document)
    return unless %w{ edge production }.include?(Rails.env)

    admin_emails = if Rails.env.edge?
      %w{ wootie@polymathic.me wilson@polymathic.me kaitlen@polymathic.me shaheebroshan@watchtowerbenefits.com }
    else
      %w{ richardperrott@watchtowerbenefits.com ryansachtjen@watchtowerbenefits.com shaheebroshan@watchtowerbenefits.com }
    end

    document_link = admin_document_url(document)
    unfinished_documents = document.project.documents.where.not(state: 3) # all documents NOT finalized (3)

    broker = document.user
    due_in = document.due_date.strftime("%Y/%m/%d")

    copy = <<-COPY
    Hello Meatparser!

    A new proposal was uploaded by #{broker.email}. Finalize the data by #{due_in} to meet the 24 hour deadline.
    #{document_link}

    This proposal has #{unfinished_documents.size} other documents that are not yet finalized.

    COPY

    unfinished_documents.each do |doc|
      copy += <<-COPY
      #{admin_document_url(doc)}

      COPY
    end

    copy += <<-COPY
    - Watchtower
    COPY

    Pony.mail to: admin_emails,
              from: 'docbot@watchtowerapp.com',
              subject: "New #{document.project.name} upload: Deadline by #{due_in}",
              body: copy
  end

  def sources_from_params
    params[:file].map { |index, file| @document.sources.new(file: file) }
  end

  def document_params
    params.require(:document).permit(:document_type)
  end

  def load_project
    @project = current_user.all_projects.find(params[:project_id])
  end

  def load_document
    @document = @project.documents.find(params[:id])
  end
end
