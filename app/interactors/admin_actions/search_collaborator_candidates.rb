module AdminActions
  class SearchCollaboratorCandidates
    attr_accessor :form_answer,
      :account,
      :existing_collaborators,
      :candidates,
      :query,
      :error

    def initialize(form_answer, query = nil)
      @query = query[:query]
      @form_answer = form_answer
      @account = form_answer.account
      @existing_collaborators = account.users
    end

    def run
      if query.present?
        @candidates = if existing_collaborators.present?
          User.by_query_part(query)
              .not_in_ids(existing_collaborators.pluck(:id))
        else
          User.by_query_part(query)
        end

        nothing_found! if @candidates.blank?
      else
        nothing_found!
      end
    end

    def valid?
      @error.blank?
    end

    private

    def nothing_found!
      @error = "Nothing found!"
    end
  end
end
