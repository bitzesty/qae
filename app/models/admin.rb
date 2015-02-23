class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  extend Enumerize

  enumerize :role, in: %w[admin lead_assessor assessor], predicates: true
  validates :role, :first_name, :last_name, presence: true

  def ability
    @ability ||= Ability.new(self)
  end

  delegate :can?, to: :ability
end
