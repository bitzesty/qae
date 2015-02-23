class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  extend Enumerize

  enumerize :role, in: %w[admin lead_assessor assessor], predicates: true
  validates :role, :first_name, :last_name, presence: true

  scope :admins, -> { where(role: "admin") }
  scope :assessors, -> { where(role: %w[lead_assessor assessor]) }
  has_many :form_answer_attachments, as: :attachable
end
