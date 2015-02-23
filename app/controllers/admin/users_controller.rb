class Admin::UsersController < Admin::BaseController
  before_filter :find_user, only: [:show, :edit, :update, :destroy]

  def index
    params[:search] ||= UserSearch::DEFAULT_SEARCH

    @search = UserSearch.new(User.all).search(params[:search])
    @users = @search.results.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.agreed_with_privacy_policy = '1'

    @user.save
    respond_with :admin, @user
  end

  def update
    if user_params[:password].present?
      @user.update(user_params)
    else
      @user.update_without_password(user_params)
    end

    respond_with :admin, @user
  end

  def destroy
    @user.destroy
    respond_with :admin, @user
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :role, :password, :password_confirmation)
  end
end
