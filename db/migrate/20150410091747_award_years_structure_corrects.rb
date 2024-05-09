class AwardYearsStructureCorrects < ActiveRecord::Migration[4.2]
  def up
    # Clean up existing Settings
    Settings.destroy_all

    # Add award_year_id to Settings (without null: false)
    remove_column :settings, :year
    add_column :settings, :award_year_id, :integer
    Settings.reset_column_information

    # Create award_years table
    create_table :award_years do |t|
      t.integer :year, null: false
      t.timestamps null: false
    end

    # Populate Award Years.
    # Settings and Deadlines will be created automatically
    unless Rails.env.test?
      AwardYear::AVAILABLE_YEARS.each do |year|
        AwardYear.create!(year: year)
      end
    end

    # # Add null: false and index for award_year_id for Settings
    change_column :settings, :award_year_id, :integer, null: false
    add_index :settings, :award_year_id

    # # Add award_year_id to FormAnswer (without null: false)
    add_column :form_answers, :award_year_id, :integer
    FormAnswer.reset_column_information

    # # Populate award_year_id value for existing FormAnswers
    FormAnswer.all.each do |form_answer|
      award_year_attr = form_answer.attributes["award_year"]
      award_year = AwardYear.find_by(year: award_year_attr) || AwardYear.first
      form_answer.update_column(:award_year_id, award_year.id)
    end

    # # Remove award_year column from FormAnswer
    remove_column :form_answers, :award_year

    # # # Add null: false and index for award_year_id for FormAnswer
    change_column :form_answers, :award_year_id, :integer, null: false
    add_index :form_answers, :award_year_id
  end

  def down
    add_column :settings, :year, :integer
    remove_column :settings, :award_year_id
    remove_column :form_answers, :award_year_id
    drop_table :award_years
  end
end
