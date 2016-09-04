class Document < ActiveRecord::Base
  include DistillableAttributes
  include ActsAsArchivable

  REVIEW_PERIOD = 24.hour

  belongs_to :project
  belongs_to :carrier
  has_many :products, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :sources, dependent: :destroy
  has_many :dynamic_values, as: :parent

  serialize :selectors, Hash

  enum state: [ :data_entry, :needs_review, :reviewed, :finalized ]

  delegate :user, to: :project

  after_validation :notify_broker_of_finalized_proposal, if: proc{|document| document.state_changed? && document.finalized? }

  def review_for_state
    reviews.where(proposal_state: read_attribute(:state)).first_or_create
  end

  def due_date
    created_at + REVIEW_PERIOD
  end

  private

  def notify_broker_of_finalized_proposal
    return unless %w{ edge production }.include?(Rails.env)

    broker_email = project.user.email
    filenames = sources.map{|source| source.file_file_name }.compact.join(',')
    carrier_name = carrier.try(:name) || "the carrier"

    body_copy = <<-COPY
Hello,

Thank you for using WatchTower! The document titled "#{filenames}" that you uploaded for #{carrier_name} has been processed. If you would like to view your processed document please visit us at http://www.watchtowerbenefits.com/.

Thank You!

WatchTower
222 W Merchandise Mart Plaza, 12th floor
Chicago, IL 60654

Have a question? Please contact us at support@watchtowerbenefits.com and a member of our team will be happy to assist you.
    COPY

    Pony.mail to: broker_email,
              from: 'support@watchtowerbenefits.com',
              subject: "Your WatchTower document is ready - #{filenames}",
              body: body_copy
  end
end
