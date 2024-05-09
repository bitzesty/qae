class FormPaginator
  attr_reader :form_answer, :params, :user, :scope

  def initialize(form_answer, user, full_params = {})
    @form_answer = form_answer
    @user = user
    @params = full_params[:search] || FormAnswerSearch::DEFAULT_SEARCH

    base_scope = if user.is_a?(Assessor)
      assessors_scope = user.applications_scope(award_year)
      picker = CurrentAwardTypePicker.new(user, full_params)

      if params[:query].blank? && picker.show_award_tabs_for_assessor?
        assessors_scope.where(award_type: form_answer.award_type)
      else
        assessors_scope
      end
    else
      award_year.form_answers
    end

    search = FormAnswerSearch.new(base_scope, user).search(params)
    search.ordered_by = "company_or_nominee_name" unless search.ordered_by

    @scope ||= search.results.group("form_answers.id").includes(:comments)
  end

  def next_entry
    if !defined?(@next_entry)
      @next_entry = (!last?) ? scope.find(ids[position + 1]) : nil
    else
      @next_entry
    end
  end

  def prev_entry
    if !defined?(@prev_entry)
      @pref_entry = (!first?) ? scope.find(ids[position - 1]) : nil
    else
      @prev_entry
    end
  end

  def first?
    !position || position == 0
  end

  def last?
    !position || position == ids.count - 1
  end

  private

  def ids
    @ids ||= scope.select("form_answers.id").map(&:id)
  end

  def position
    @position ||= ids.find_index(form_answer.id)
  end

  def award_year
    form_answer.award_year
  end
end
