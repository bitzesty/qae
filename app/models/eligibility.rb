class Eligibility < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  validates :user, presence: true

  def self.questions
    @questions ||= []
  end

  def self.property(name, options = {})
    values = options[:values]

    store_accessor :answers, name

    if values && values.any?
      enumerize name, in: values
    elsif options[:boolean]
      define_method "#{name}?" do
        ['1', 'true', true].include?(public_send(name))
      end
    end

    questions << name
  end

  property :kind, values: %w[application nomination]
  property :organization_kind, values: %w[buiseness charity]
  property :industry, values: %w[automotive]
  property :based_in_uk, boolean: true
  property :self_contained_enterprise, boolean: true
  property :has_management_and_two_employees, boolean: true
  property :demonstrated_comercial_success, boolean: true
end
