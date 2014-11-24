class Admin::UsersController < Admin::BaseController
  before_filter :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.order(:email).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    respond_with :admin, @user
  end

  def update
    @user.update_attributes(user_params)
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
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
