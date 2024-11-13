require "rails_helper"

describe AccountsController do
  let(:old_password) { "^#ur9EkLm@1W+OaDvgTT" }
  let(:new_password) { "^#ur9EkLm@1W+OaDvg" }

  let(:user) { create(:user, :completed_profile, password: old_password, password_confirmation: old_password) }

  before do
    sign_in user
  end

  describe "PATCH #update_password_settings" do
    context "with valid params" do
      it "updates the password and redirects to the dashboard with a success message" do
        patch :update_password_settings, params: {
          user: {
            current_password: old_password,
            password: new_password,
            password_confirmation: new_password,
          },
        }

        user.reload
        expect(user.valid_password?(new_password)).to be_truthy
        expect(flash[:notice]).to eq("Your account details were successfully saved")
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "with invalid params" do
      it "does not update the password and renders the password_settings template with an error message" do
        patch :update_password_settings, params: {
          user: {
            current_password: "wrong_password",
            password: new_password,
            password_confirmation: new_password,
          },
        }

        user.reload
        expect(user.valid_password?(new_password)).to be_falsey
        expect(flash[:alert]).to eq("Error updating your password")
        expect(response).to render_template(:password_settings)
      end

      it "sets @active_step to 5" do
        patch :update_password_settings, params: {
          user: {
            current_password: "wrong_password",
            password: new_password,
            password_confirmation: new_password,
          },
        }

        expect(assigns(:active_step)).to eq(5)
      end
    end
  end
end
