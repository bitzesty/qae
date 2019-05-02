class AddDebounceApiResponseCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :debounce_api_response_code, :string
  end
end
