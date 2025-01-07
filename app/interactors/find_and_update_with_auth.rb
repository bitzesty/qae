class FindAndUpdateWithAuth
  attr_reader :success, :errors, :user

  def initialize(auth:, model:)
    @model = model
    @sso_uid = auth.uid
    @sso_info = auth.info
    @sso_provider = auth.provider
  end

  def run
    @user = find_or_create_user
    @success = @user.persisted?
    @errors = @user.errors unless @success
    self
  end

  private

  # 1 - check if they have already set up sso; when they have update them to ensure we capture the current email/first_name/last_name
  # 2 - check if the user already existed prior to sso; when they do update them with the auth details
  # 3 - finally if they dont exist; create them from the auth details
  def find_or_create_user
    find_and_update_with_auth(sso_provider: @sso_provider, sso_uid: @sso_uid) || find_and_update_with_auth(email: @sso_info.email) || create_from_auth
  end

  def find_and_update_with_auth(conditions)
    raise "conditions should not be nil: #{conditions}" if conditions.compact.empty?

    existing = @model.find_by(**conditions)
    return unless existing

    @model.update(
      existing.id,
      sso_provider: @sso_provider,
      sso_uid: @sso_uid,
      email: @sso_info.email,
      first_name: @sso_info.first_name,
      last_name: @sso_info.last_name,
    )
  end

  def create_from_auth
    @model.create(
      email: @sso_info.email,
      first_name: @sso_info.first_name,
      last_name: @sso_info.last_name,
      sso_uid: @sso_uid,
      sso_provider: @sso_provider,
    )
  end
end
