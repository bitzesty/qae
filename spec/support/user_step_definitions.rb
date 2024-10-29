module UserStepDefinitions
  def login_admin(admin, stub_sso: true)
    if stub_sso
      stub_sso_request(
        email: admin.email,
        first_name: admin.first_name,
        last_name: admin.last_name,
        provider: :dbt_staff_sso,
      )
    end

    visit "/admins/sign_in"
    click_link "Sign in with Dbt Staff Sso"
  end

  def stub_sso_request(email:, first_name:, last_name:, provider:, uid: SecureRandom.uuid, auth: OmniAuth)
    auth.config.mock_auth[provider] = AuthStruct.new(
      uid,
      provider,
      InfoStruct.new(email, first_name, last_name),
    )
  end

  private

  AuthStruct = Struct.new(:uid, :provider, :info)
  InfoStruct = Struct.new(:email, :first_name, :last_name)
end
