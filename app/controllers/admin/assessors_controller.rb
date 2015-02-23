class Admin::AssessorsController < Admin::BaseController
  before_filter :find_assessor, only: [:show, :edit, :update, :destroy]

  def index
    params[:search] ||= AssessorSearch::DEFAULT_SEARCH

    @search = AssessorSearch.new(Admin.where(role: %w[lead_assessor assessor])).search(params[:search])
    @assessors = @search.results.page(params[:page])
  end

  def new
    @assessor = Admin.new
  end

  def create
    @assessor = Admin.new(assessor_params)

    @assessor.save
    respond_with :admin, @assessor, location: admin_assessor_path(@assessor)
  end

  def update
    if assessor_params[:password].present?
      @assessor.update(assessor_params)
    else
      @assessor.update_without_password(assessor_params)
    end

    respond_with :admin, @assessor, location: admin_assessor_path(@assessor)
  end

  def destroy
    @assessor.destroy
    respond_with :admin, @assessor, location: admin_assessors_path
  end

  private

  def find_assessor
    @assessor = Admin.where(role: %w[lead_assessor assessor]).find(params[:id])
  end

  def assessor_params
    params.require(:assessor).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role)
  end
end
