class AddOmniauthToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :sso_provider, :string
    add_column :admins, :sso_uid, :string
  end
end
