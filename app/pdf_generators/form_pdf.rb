require "prawn/measurement_extensions"

class FormPdf < Prawn::Document
  attr_reader :user, :form_answer, :answers, :filled_answers, :award_form, :steps

  # HERE are dictionary for sub attributes. 
  # We have sub attributes in more complex questions
  # like 'principal_address', 'head_of_business' and so on, which are no stored in questions
  # They are hardcoded in views.
  # So we use this dictionary  in terms to fetch proper title and position in list

  BASE_SUB_ATTRIBUTES_DICTIONARY = {
    principal_address: [
      ["building", "Building"],
      ["street", "Street"],
      ["city", "Town or city"],
      ["country", "Country"],
      ["postcode", "Postcode"]
    ],
    head_of_business: [
      ["title", "Title"],
      ["first_name", "First name"],
      ["last_name", "Last name"],
      ["honours", "Personal Honours"]
    ]
  }  

  def initialize(form_answer)
    super()
    @form_answer = form_answer
    @award_form = form_answer.award_form
    @user = form_answer.user

    @answers = ActiveSupport::HashWithIndifferentAccess.new(form_answer.document)
    @filled_answers = answers.select { |k, v| v.present? }
    @steps = [award_form.steps.first]
    
    generate!
  end

  def generate!
    main_header

    steps.each_with_index do |step, index|
      render_step(step)
    end
  end

  def step_header_title(step)
    "Step #{step.index} of #{steps.length}: #{step.title}"
  end

  def step_header(step)
    text step_header_title(step), style: :bold, 
                                  size: 18, 
                                  align: :left
    default_bottom_margin
  end

  def render_step(step)
    if step.index.to_i != 1
      start_new_page margin: 5.mm 
    end

    step_header(step)
    cached_questions = step.questions

    step.questions.select do |question| 
      render_question(cached_questions, question) 
    end
  end

  def render_question(cached_questions, question)
    answer = fetch_answer(question)

    if answer.present?
      question_block(question, answer) if answer.present?
    else
      sub_answers = fetch_sub_answers(cached_questions, question)

      if sub_answers.any?
        complex_question(question, sub_answers)
      end
    end
  end

  def question_title(question)
    "#{question.ref} #{question.title}"
  end

  def question_block(question, answer)
    default_bottom_margin
    text question_title(question), style: :bold
    
    default_bottom_margin
    text answer, style: :italic
  end

  def complex_question(question, sub_answers)
    default_bottom_margin
    text question_title(question), style: :bold

    if sub_answers.length > 1
      sub_answers.each do |sub_question, sub_answer|
        sub_question_block(sub_question, sub_answer) if sub_answer.present?
      end
    else
      first_sub_question = sub_answers[0][1]
      sub_question_block_without_title(first_sub_question)
    end
  end

  def sub_question_block(sub_question, sub_answer)
    default_bottom_margin
    text sub_question, style: :bold
    
    default_bottom_margin
    text sub_answer, style: :italic
  end

  def sub_question_block_without_title(sub_answer)
    default_bottom_margin
    text sub_answer, style: :italic
  end

  def fetch_sub_answers(cached_questions, question)
    question_main_key = question.key.to_s

    log_this "question_main_key: #{question_main_key}"
    log_this "filled_answers_by_key(question_main_key): #{filled_answers_by_key(question_main_key)}"

    filled_answers_by_key(question_main_key).map do |key, value|
      sub_section = BASE_SUB_ATTRIBUTES_DICTIONARY[question_main_key.to_sym]

      if sub_section.present?
        position = detect_sub_question_position(question_main_key, sub_section, key)
      end

      [
        detect_title(question_main_key, sub_section, key), 
        answer_based_on_type(key, value),
        position || 0
      ]
    end.sort do |a, b|
      a[2] <=> b[2]
    end
  end

  def detect_sub_question_position(question_main_key, sub_section, key)
    sub_question_block = fetch_sub_question_block_from_dictionary(question_main_key, sub_section, key)

    sub_section.index do |element|
      element == sub_question_block
    end
  end

  def filled_answers_by_key(question_main_key)
    filled_answers.select do |key, value|
      key.to_s.include?(question_main_key)
    end
  end

  def detect_title(question_main_key, sub_section, key)
    if sub_section.present?
      sub_question_block = fetch_sub_question_block_from_dictionary(question_main_key, sub_section, key)

      sub_question_block.present? ? sub_question_block[1] : 'TITLE AND POSITION IS NOT DEFINED (FIXME PLEASE!)'
    end
  end

  def fetch_sub_question_block_from_dictionary(question_main_key, sub_section, key)
    sub_section.select do |a| 
      a[0] == key.to_s.gsub("#{question_main_key}_", '')
    end[0]
  end

  def fetch_answer(question)
    value = begin
      # if JSON structure like array in value:
      JSON.parse(answers[question.key])
    rescue
      # if string like company_name == 'Bitzesty'
      answers[question.key]
    end

    value = answer_based_on_type(question.key, value) if value.present?
    value
  end

  def answer_based_on_type(key, value)
    if key.to_s.include?('country')
      ISO3166::Country.countries.select do |country| 
        country[1] == value.strip
      end[0][0]
    else
      value
    end
  end

  def main_header
    offset = 110.mm

    # Print a bounding box
    stroke_rectangle [0, 138.5.mm + offset], 200.mm, 24.mm

    # Print the logo
    logo = "#{Rails.root}/app/assets/images/logo.png"
    image logo, at: [2.mm, 137.5.mm + offset], width: 25.mm

    # Add dividing line between logo and office address
    stroke_line 29.mm, 138.5.mm + offset, 29.mm, 114.5.mm + offset

    # Add award title near the logo
    text_box form_answer.decorate.award_application_title, 
             default_text_box_properties.merge({
               at: [32.mm, 142.mm + offset]
             })

    # Add user general info below the award title
    text_box user.decorate.general_info, 
             default_text_box_properties.merge({
               at: [32.mm, 135.mm + offset]
             })

    # Add fomr URN below user general information
    text_box form_answer.urn.present? ? form_answer.urn : "URN is undefined", 
             default_text_box_properties.merge({
               at: [32.mm, 129.mm + offset]
             })

    move_down 40.mm
  end

  private

  def default_bottom_margin
    move_down 5.mm
  end

  def default_text_box_properties
    {
      width: 200.mm, 
      height: 20.mm, 
      size: 18, style: :bold, 
      align: :left, 
      valign: :center      
    }
  end

  def log_this(m)
    unless Rails.env.production?
      Rails.logger.info m
      puts m
    end
  end
end