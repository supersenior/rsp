module Admin::PagesHelper

  # Returns documents grouped by state.  The return structure is
  # {State Name => {documents: Array, description: String}}
  def documents_by_state
    {
      "data_entry"    => {documents: [], description: "Proposals that need data entry"},
      "needs_review"  => {documents: [], description: "Proposals that need review"},
      "reviewed"      => {documents: [], description: "Proposals that have been reviewed"},
      "finalized"     => {documents: [], description: "Proposals that have been finalized"}
    }.tap do |states|
      Document.includes(project: :employer).find_each do |document|
        states[document.state][:documents] << document
      end
    end
  end
end
