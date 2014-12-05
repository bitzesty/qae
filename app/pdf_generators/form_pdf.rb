require "prawn/measurement_extensions"

class FormPdf < Prawn::Document
  attr_reader :user, :form_answer, :answers, :answered_question_keys, :award_form, :steps

  def initialize(form_answer)
    super()
    @form_answer = form_answer
    @answers = ActiveSupport::HashWithIndifferentAccess.new(
      form_answer.document.reject { |k, v| v.nil? }
    )
    @answered_question_keys = @answers.keys
    @user = form_answer.user
    @award_form = form_answer.award_form
    @steps = award_form.steps
    
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
    move_down 5.mm
  end

  def render_step(step)
    if step.index.to_i != 1
      start_new_page margin: 5.mm 
    end

    step_header(step)

    answered_step_questions(step).each do |question|
      question_block(question)
    end
  end

  def question_title(question)
    "#{question.ref} #{question.title}"
  end

  def question_block(question)
    move_down 5.mm
    text question_title(question), style: :bold
    
    move_down 5.mm
    text answer(question), style: :italic
  end

  def answer(question)
    res = begin
      # if JSON structure like array in value:
      JSON.parse(answers[question.key])
    rescue
      # if string like company_name == 'Bitzesty'
      answers[question.key]
    end

    question.is_a?(Array) ? res.join(", ") : res
  end

  def answered_step_questions(step)
    step.questions.select do |q| 
      answered_question_keys.include? q.key.to_s
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
    text_box form_answer.decorate.award_application_title, at: [32.mm, 142.mm + offset], 
                                                           width: 100.mm, 
                                                           height: 20.mm, 
                                                           size: 18, style: :bold, 
                                                           align: :left, 
                                                           valign: :center

    # Add user general info below the award title
    text_box user.decorate.general_info, at: [32.mm, 135.mm + offset], 
                                         width: 100.mm, 
                                         height: 20.mm, 
                                         size: 14, style: :bold, 
                                         align: :left, 
                                         valign: :center

    # Add fomr URN below user general information
    text_box form_answer.urn, at: [32.mm, 129.mm + offset], 
                                      width: 100.mm, 
                                      height: 20.mm, 
                                      size: 14, style: :bold, 
                                      align: :left, 
                                      valign: :center

    move_down 40.mm
  end
end