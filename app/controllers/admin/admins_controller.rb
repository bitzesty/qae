class Admin::AdminsController < Admin::BaseController
  before_filter :find_admin, only: [:show, :edit, :update, :destroy]

  def index
    params[:search] ||= AdminSearch::DEFAULT_SEARCH

    @search = AdminSearch.new(Admin.where(role: "admin")).search(params[:search])
    @admins = @search.results.page(params[:page])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    @admin.role = "admin"

    @admin.save
    respond_with :admin, @admin
  end

  def update
    if admin_params[:password].present?
      @admin.update(admin_params)
    else
      @admin.update_without_password(admin_params)
    end

    respond_with :admin, @admin
  end

  def destroy
    @admin.destroy
    respond_with :admin, @admin
  end

  private

  def find_admin
    @admin = Admin.where(role: "admin").find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
