class Eligibility < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  validates :user, presence: true

  after_save :set_passed

  def self.questions
    @questions.keys
  end

  def self.label(name)
    @questions[name.to_sym][:label]
  end

  def self.additional_label(name)
    @questions[name.to_sym][:additional_label] || label(name)
  end

  def self.boolean_question?(name)
    !!@questions[name.to_sym][:boolean]
  end

  def self.integer_question?(name)
    !!@questions[name.to_sym][:positive_integer]
  end

  def self.hidden_question?(name)
    !!@questions[name.to_sym][:hidden]
  end

  def self.questions_storage
    @questions
  end

  def self.property(name, options = {})
    @questions ||= {}

    values = options[:values]

    store_accessor :answers, name

    if values && values.any?
      enumerize name, in: values
    elsif options[:boolean]
      define_method "#{name}?" do
        ['1', 'true', 'yes', true].include?(public_send(name))
      end

      validates name, presence: true unless self == Eligibility::Basic
    elsif options[:positive_integer]
      validates name, numericality: { only_integer: true, greater_than_0: true, allow_nil: true } unless self == Eligibility::Basic
    end

    @questions.merge!(name => options)
  end

  def eligible?
    self.class.questions.all? do |question|
      answer = answers && answers[question.to_s]
      answer_valid?(question, answer)
    end
  end

  def sorted_answers
    return {} unless answers

    @sorted_answers ||= begin
      sorted = {}

      self.class.questions.each do |question|
        if answers[question.to_s]
          sorted[question.to_s] = answers[question.to_s]
        end
      end

      sorted
    end
  end

  private

  def set_passed
    if eligible?
      update_column(:passed, true)
    end
  end

  def answer_valid?(question, answer)
    acceptance_criteria = self.class.questions_storage[question.to_sym][:accept].to_s
    validator = "Eligibility::Validation::#{acceptance_criteria.camelize}Validation".constantize.new(self, question, answer)
    validator.valid?
  end
end
