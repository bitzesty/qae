class Admin::AssessorsController < Admin::UsersController
  before_action :find_resource,
                except: %i[
                  index
                  new
                  create
                  suspension_status
                  confirm_bulk_activate_pi
                  confirm_bulk_activate_dt
                  bulk_activate_pi
                  bulk_activate_dt
                  confirm_bulk_deactivate_pi
                  confirm_bulk_deactivate_dt
                  bulk_deactivate_pi
                  bulk_deactivate_dt
                ]

  def index
    params[:search] ||= AssessorSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize :assessor, :index?

    @search = AssessorSearch.new(Assessor.all)
                             .search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Assessor.new
    authorize @resource, :create?
  end

  def confirm_activate
    @form = ConfirmationForm.new("activate_assessor")

    authorize @resource, :activate?
  end

  def confirm_deactivate
    @form = ConfirmationForm.new("deactivate_assessor")
    authorize @resource, :deactivate?
  end

  def activate
    @form = ConfirmationForm.new("activate_assessor", params[:confirmation_form])
    authorize @resource, :activate?

    if @form.valid?
      if @form.confirmed?
        @resource.unsuspend!
        flash[:notice] = "The assessor has been re-activated."
      end

      redirect_to edit_admin_assessor_path(@resource)
    else
      render :confirm_activate
    end
  end

  def deactivate
    @form = ConfirmationForm.new(params[:confirmation_form])
    authorize @resource, :deactivate?

    @form = ConfirmationForm.new("deactivate_assessor", params[:confirmation_form])

    if @form.valid?
      if @form.confirmed?
        @resource.suspend!
        flash[:notice] = "The assessor has been deactivated."
      end

      redirect_to edit_admin_assessor_path(@resource)
    else
      render :confirm_deactivate
    end
  end

  def suspension_status
    authorize Assessor, :activate?
    # if any of the assessors are active, we assume that the status is active
    @dt_status = Assessor.trade_and_development.not_suspended.exists? ? "active" : "suspended"
    @pi_status = Assessor.mobility_and_innovation.not_suspended.exists? ? "active" : "suspended"
  end

  def confirm_bulk_activate_pi
    authorize Assessor, :activate?
    @form = ConfirmationForm.new("bulk_activate_assessors")
  end

  def confirm_bulk_deactivate_pi
    authorize Assessor, :deactivate?
    @form = ConfirmationForm.new("bulk_deactivate_assessors")
  end

  def confirm_bulk_activate_dt
    authorize Assessor, :activate?
    @form = ConfirmationForm.new("bulk_activate_assessors")
  end

  def confirm_bulk_deactivate_dt
    authorize Assessor, :deactivate?
    @form = ConfirmationForm.new("bulk_deactivate_assessors")
  end

  def bulk_activate_pi
    authorize Assessor, :activate?
    @form = ConfirmationForm.new("bulk_activate_assessors", params[:confirmation_form])

    if @form.valid?
      if @form.confirmed?
        Assessor.mobility_and_innovation.update_all(suspended_at: nil)
        flash[:notice] = "Assessors assigned to Promoting Opportunity and Innovation awards have been re-activated."
      end

      redirect_to suspension_status_admin_assessors_path
    else
      render :confirm_bulk_activate_pi
    end
  end

  def bulk_deactivate_pi
    authorize Assessor, :deactivate?
    @form = ConfirmationForm.new("bulk_deactivate_assessors", params[:confirmation_form])

    if @form.valid?
      if @form.confirmed?
        Assessor.mobility_and_innovation.update_all(suspended_at: Time.current)
        flash[:notice] = "Assessors assigned to Promoting Opportunity and Innovation awards have been temporarily deactivated."
      end

      redirect_to suspension_status_admin_assessors_path
    else
      render :confirm_bulk_deactivate_pi
    end
  end

  def bulk_activate_dt
    authorize Assessor, :activate?
    @form = ConfirmationForm.new("bulk_activate_assessors", params[:confirmation_form])

    if @form.valid?
      if @form.confirmed?
        Assessor.trade_and_development.update_all(suspended_at: nil)
        flash[:notice] = "Assessors assigned to Sustainable Development and International Trade awards have been re-activated."
      end

      redirect_to suspension_status_admin_assessors_path
    else
      render :confirm_bulk_activate_dt
    end
  end

  def bulk_deactivate_dt
    authorize Assessor, :deactivate?
    @form = ConfirmationForm.new("bulk_activate_assessors", params[:confirmation_form])

    if @form.valid?
      if @form.confirmed?
        Assessor.trade_and_development.update_all(suspended_at: Time.current)
        flash[:notice] = "Assessors assigned to Sustainable Development and International Trade awards have been temporarily deactivated."
      end

      redirect_to suspension_status_admin_assessors_path
    else
      render :confirm_bulk_deactivate_dt
    end
  end

  def create
    @resource = Assessor.new(resource_params)
    @resource.skip_password_validation = true
    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_assessors_path : nil

    render_flash_message_for(@resource,
                             message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.uniq.join("<br />"))

    respond_with :admin, @resource, location:
  end

  def update
    authorize @resource, :update?
    @resource.skip_password_validation = true
    @resource.update_without_password(resource_params)

    render_flash_message_for(@resource,
                             message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.uniq.join("<br />"))

    respond_with :admin, @resource, location: admin_assessors_path
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    render_flash_message_for(@resource,
                             message: @resource.errors.none? ? nil : @resource.errors.messages.values.flatten.uniq.join("<br />"))

    respond_with :admin, @resource, location: admin_assessors_path
  end

  private

  def find_resource
    @resource = Assessor.find(params[:id])
  end

  def resource_params
    params.require(:assessor)
      .permit(:email,
              :company,
              :first_name,
              :last_name,
              :telephone_number,
              :trade_role,
              :innovation_role,
              :development_role,
              :mobility_role,
              :promotion_role)
  end
end
