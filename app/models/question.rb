# == Schema Information
#
# Table name: questions
#
#  id                 :integer          not null, primary key
#  form_step_id       :integer
#  question_id        :integer
#  title              :string(255)
#  description        :text
#  element_type       :string(255)
#  placement          :integer
#  note_above         :text
#  note_below         :text
#  hint_above         :text
#  hint_below         :text
#  visible            :boolean
#  is_subquestion     :boolean
#  is_optional        :boolean
#  css_class          :string(255)
#  css_size           :integer
#  chars_limited      :boolean
#  view_template_path :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Question < ActiveRecord::Base

  POSSIBLE_TYPES = [
    'text_input',
    'text_area',
    'radio',
    'complex_radio', # Radio buttons with advanced questions
    'checkbox',
    'complex_checkbox', # Checkbox with advanced questions
    'select',
    'complex_select', # Select with advanced questions
    'group', # complex question with couple inputs,
    'date',
    'file'
  ]

  CSS_CLASSES = %w(small medium large)

  begin :associations 
    belongs_to :form_step
    belongs_to :question

    has_many :question_options, dependent: :destroy
  end

  begin :validations
    validates :title, :placement, presence: true

    validates :element_type,
              presence: true,
              inclusion: {
                in: POSSIBLE_TYPES
              }

    validates :css_size,
          allow_nil: true,
          allow_blank: true,
          numericality: {
            greater_than_or_equal_to: 0,
            less_than_or_equal_to: 12
          }

    validates :css_class,
          allow_nil: true,
          allow_blank: true,
          inclusion: {
            in: CSS_CLASSES
          }
  end
end
