class CreateEligibilities < ActiveRecord::Migration
  def change
    create_table :eligibilities do |t|
      t.references :user, index: true
      t.hstore :answers
      t.boolean :passed

      t.timestamps
    end
  end
end
