class AddHstore < ActiveRecord::Migration[4.2]
  def up
    enable_extension :hstore
  end

  def down
    disable_extension :hstore
  end
end
