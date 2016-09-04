class Source < ActiveRecord::Base
  VALID_FILE_TYPES = [
    "application/pdf",
    "application/msword",
    "text/html",
    "text/rtf",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
  ]

  belongs_to :document

  has_attached_file :file#, processors: [:html], styles: { original: {} }

  validates_attachment_content_type :file, :content_type => VALID_FILE_TYPES
end
