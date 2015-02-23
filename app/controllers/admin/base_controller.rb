class Admin::BaseController < ApplicationController
  layout "application-admin"

  before_action :authenticate_admin!
  skip_before_action :authenticate_user!
  skip_before_action :restrict_access_if_admin_in_read_only_mode!

  before_action :check_read_permissions!, only: [:index, :show]
  before_action :check_create_permissions!, only: [:new, :create]
  before_action :check_update_permissions!, only: [:edit, :update]
  before_action :check_destroy_permissions!, only: [:destroy]
  before_action :check_custom_permissions!, except: [:index, :show, :new, :create, :edit, :update, :destroy]

  private

  %w[read create update destroy].each do |act|
    define_method "check_#{act}_permissions!" do
      head 401 unless current_admin.can?(act.to_sym, controller_name.to_sym)
    end
  end

  def check_custom_permissions!
    head 401 unless current_admin.can?(action_name.to_sym, controller_name.to_sym)
  end
end
