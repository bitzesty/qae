class Judge::CaseSummariesController < Judge::BaseController
  def index
    authorize :case_summary, :index?
  end
end
