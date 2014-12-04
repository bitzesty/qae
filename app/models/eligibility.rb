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

  def self.boolean_question?(name)
    !!@questions[name.to_sym][:boolean]
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
        ['1', 'true', true].include?(public_send(name))
      end
    end

    @questions.merge!(name => options)
  end

  def eligible?
    raise NotImplementedError
  end

  private

  def set_passed
    raise NotImplementedError
  end
end
