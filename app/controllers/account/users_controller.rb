class Account::UsersController < Account::BaseController
  before_filter :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = current_user.account.users.where.not(id: current_user.id).order(:email).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.agreed_with_privacy_policy = '1'
    @user.account = current_user.account

    @user.save
    respond_with :account, @user
  end

  def update
    @user.update(user_params)
    respond_with :account, @user
  end

  def destroy
    if @user != current_user
      @user.destroy
      respond_with :account, @user
    else
      head :forbidden
    end
  end

  private

  def find_user
    @user = current_user.account.users.find(params[:id])
    head :forbidden if @user == current_user
  end

  def user_params
    params.require(:user).permit(:email, :role, :password, :password_confirmation)
  end
end
