require "prawn/measurement_extensions"

class FormPdf < Prawn::Document
  attr_reader :user, :form_answer, :answers, :award_form, :steps

  # HERE are dictionary for sub attributes. 
  # We have sub attributes in more complex questions
  # like 'principal_address', 'head_of_business' and so on, which are no stored in questions
  # They are hardcoded in views.
  # So we use this dictionary  in terms to fetch proper title and position in list

  UNDEFINED_TITLE = 'TITLE AND POSITION IS NOT DEFINED (FIXME PLEASE!)'

  FIVE_FINANCIAL_YEARS = [
    ["1of5", "1/10/2013 - 30/09/2014"],
    ["2of5", "1/10/2012 - 30/09/2013"],
    ["3of5", "1/10/2011 - 30/09/2012"],
    ["4of5", "1/10/2010 - 30/09/2011"],
    ["5of5", "1/10/2009 - 30/09/2010"],
    ["1of2", "1/10/2013 - 30/09/2014"],
    ["2of2", "1/10/2012 - 30/09/2013"],
    ["comments", "Explanation"]
  ]

  FIVE_YEAR_STANDART_BLOCK = [
    ["1of5", "Ending in 1/11/2013"],
    ["2of5", "Ending in 1/11/2012"],
    ["3of5", "Ending in 1/11/2011"],
    ["4of5", "Ending in 1/11/2010"],
    ["5of5", "Ending in 1/11/2009"],
    ["1of2", "Year ending in financial year 1"],
    ["2of2", "Year ending in financial year 2"]
  ]

  TABLE_BASED_DATA = [
    'financial_year_dates',
    'total_turnover',
    'exports',
    'net_profit',
    'total_net_assets'
  ]

  ANSWER_DICTIONARY = {
    '5 plus' => '2-4 years',
    '2 plus' => '5 years or more',
    'entire_business' => 'The entire business',
    'single_product_or_service' => 'A single product or service',
    'complete_now' => 'Complete full corporate responsibility form now',
    'on' => 'I confirm that I have the consent of the Head of the applicant business (as identified in A11) to submit this entry form.'
  }

  HIDDEN_QUESTIONS = [
    "confirmation_of_consent",
    "agree_to_be_contacted",
    "contact_email_confirmation",
    "entry_confirmation"
  ]

  LOCKED_TO_HAVE_NO_SUB_QUESTIONS = [
    'contact_email'
  ]

  BASE_SUB_ATTRIBUTES_DICTIONARY = {
    principal_address: {
      building: "Building",
      street: "Street",
      city: "Town or city",
      country: "Country",
      postcode: "Postcode"
    },
    head_of_business: {
      title: "Title",
      first_name: "First name",
      last_name: "Last name",
      honours: "Personal Honours"
    },
    financial_year_dates: FIVE_FINANCIAL_YEARS,
    total_turnover: FIVE_YEAR_STANDART_BLOCK,
    exports: FIVE_YEAR_STANDART_BLOCK,
    net_profit: FIVE_YEAR_STANDART_BLOCK,
    total_net_assets: FIVE_YEAR_STANDART_BLOCK,
    contact: {
      title: "Title",
      first_name: "First name",
      last_name: "Last name",
      position: "Position",
      email_primary: "Email address",
      phone: "Telephone number"
    }
  }  

  def initialize(form_answer)
    super()
    @form_answer = form_answer
    @award_form = form_answer.award_form
    @user = form_answer.user

    @answers = ActiveSupport::HashWithIndifferentAccess.new(form_answer.document).select do |key, value|
      !HIDDEN_QUESTIONS.include?(key.to_s)
    end
    @steps = [award_form.steps.first]
    
    generate!
  end

  def filtered_questions(cached_questions)
    log_this "cached_questions: #{cached_questions.count}"

    q = cached_questions.select do |question|
      !HIDDEN_QUESTIONS.include?(question.key.to_s) #&&
      allowed_by_or_have_no_conditions?(cached_questions, question)
    end

    log_this "q: #{q.count}"

    q
  end

  def allowed_by_or_have_no_conditions?(cached_questions, question)
    conditions = question.conditions

    conditions.blank? ||
    conditions.all? do |condition|
      conditional_success?(cached_questions, condition)
    end
  end

  def conditional_success?(cached_questions, condition)
    question_key = condition.question_key
    question_value = condition.question_value

    parent_question = fetch_parent_question(cached_questions, question_key)
    parent_question_answer = fetch_answer(parent_question)

    parent_question_answer == question_value
  end

  def fetch_parent_question(cached_questions, question_key)
    cached_questions.select do |question|
      question.key.to_s == question_key.to_s
    end.first
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
    cached_questions = step.questions.reject do |question|
      HIDDEN_QUESTIONS.include?(question.key.to_s)
    end

    log_this "[filtered_questions(cached_questions)] #{filtered_questions(cached_questions).count}"

    filtered_questions(cached_questions).each do |question|
      render_question(cached_questions, question) 
    end

    # step.questions.select do |question| 
    #   render_question(cached_questions, question) 
    # end
  end

  def render_question(cached_questions, question)
    answer = humanized_answer(question)

    log_this "                                "

    log_this "[question] #{question.key.to_s}"
    log_this "[answer] #{answer}"

    sub_answers = fetch_sub_answers(cached_questions, question)

    if answer.present?
      question_block(question, answer)
    else
      if sub_answers.any?
        log_this "[sub_answers] #{sub_answers.count}"

        log_this "                                "

        complex_question(question, sub_answers)
      else
        question_block(question)
      end
    end

    # if answer.present?
    #   question_block(question, answer) if answer.present?
    # elsif is_allowed_to_have_sub_questions?(question)
    #   sub_answers = fetch_sub_answers(cached_questions, question)

    #   if sub_answers.any?
    #     complex_question(question, sub_answers)
    #   end
    # end
  end

  def question_title(question)
    ActionView::Base.full_sanitizer.sanitize(
      "#{question.ref} #{question.title.capitalize}"
    )
  end

  def question_block(question, answer=nil)
    default_bottom_margin
    text question_title(question), style: :bold
    
    default_bottom_margin
    text (answer.present? ? answer : "in the progress of filling.."), style: :italic
  end

  def complex_question(question, sub_answers)
    default_bottom_margin
    text question_title(question), style: :bold

    if sub_answers.length > 1
      sub_answers_by_type(question, sub_answers)
    else
      first_sub_question = sub_answers[0][1]
      sub_question_block_without_title(first_sub_question)
    end
  end

  def sub_answers_by_type(question, sub_answers)
    case question.key.to_s
    when *TABLE_BASED_DATA
      render_table_with_optional_extra(sub_answers)
    else
      sub_answers_standart_render(sub_answers)
    end
  end

  def sub_answers_standart_render(sub_answers)
    sub_answers.each do |sub_question, sub_answer|
      sub_question_block(sub_question, sub_answer) if sub_answer.present?
    end
  end

  def render_table_with_optional_extra(sub_answers)
    # Fetching answers, which have data formatting in question title (like 1/12/14 etc)
    cells = sub_answers.select do |a|
      a[0].match(/\/{1}[0-9]{2}\/{1}/).present? ||
      a[0].match(/Year/).present?
    end

    if cells.present?
      headers = cells.map { |a| a[0] }
      row = cells.map { |a| a[1] }
      table_lines = [headers, row]

      render_table(table_lines) 
    end

    comments = sub_answers - cells
    sub_answers_standart_render(comments) if comments.present?
  end

  def render_table(table_lines)
    default_bottom_margin
    table table_lines, row_colors: ["F0F0F0", "FFFFFF"],
                       cell_style: { size: 10, font_style: :bold }
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
    res = []

    question.sub_question_names.each_with_index do |sub_question_name, position|
      log_this "[sub_question_name] #{sub_question_name}, position: #{position}"

      answer = fetch_answer_by_key(sub_question_name)

      log_this "[filled_answers_by_key #{question_main_key}] key: #{sub_question_name}, value: #{answer}"

      res << [
        detect_title(question_main_key, sub_question_name), 
        answer ? answer_based_on_type(sub_question_name, answer) : UNDEFINED_TITLE,
        position
      ]
    end

    res = res.sort do |a, b|
      a[2] <=> b[2]
    end

    log_this "[question #{question.key}] res: #{res.inspect}"

    res
  end

  def detect_title(question_main_key, sub_question_name)
    log_this "[detect_title] question_main_key #{question_main_key.to_sym}, sub_question_name: #{sub_question_name.to_sym}"
    log_this "[BASE_SUB_ATTRIBUTES_DICTIONARY[question_main_key.to_sym]] #{BASE_SUB_ATTRIBUTES_DICTIONARY[question_main_key.to_sym]}"
    sub_question_block = BASE_SUB_ATTRIBUTES_DICTIONARY[question_main_key.to_sym][sub_question_name.to_sym]
    sub_question_block.present? ? sub_question_block[1].capitalize : UNDEFINED_TITLE
  end

  def fetch_answer(question)
    fetch_answer_by_key(question.key)
  end

  def fetch_answer_by_key(key)
    begin
      # if JSON structure like array in value:
      JSON.parse(answers[key])
    rescue
      # if string like company_name == 'Bitzesty'
      answers[key]
    end
  end

  def humanized_answer(question)
    value = fetch_answer(question)
    value = answer_based_on_type(question.key, value) if value.present?
    value
  end

  def decode_answer(value)
    res = ANSWER_DICTIONARY[value.to_s]
    res.present? ? res : value
  end

  def answer_based_on_type(key, value)
    if key.to_s.include?('country')
      ISO3166::Country.countries.select do |country| 
        country[1] == value.strip
      end[0][0]
    else
      decode_answer value
    end
  end

  def is_allowed_to_have_sub_questions?(question)
    !LOCKED_TO_HAVE_NO_SUB_QUESTIONS.include? question.key.to_s
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

    urn_block(offset) if form_answer.urn.present?

    move_down 40.mm
  end

  def urn_block(offset)
    # Add fomr URN below user general information
    text_box form_answer.urn, 
      default_text_box_properties.merge({
        at: [32.mm, 129.mm + offset]
      })
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