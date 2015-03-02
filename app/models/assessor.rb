class Assessor < ActiveRecord::Base
  include PgSearch
  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :first_name, :last_name, :role, presence: true
  has_many :form_answer_attachments, as: :attachable

  enumerize :role, in: %w[lead regular]

  pg_search_scope :basic_search,
                  against: [
                    :first_name,
                    :last_name,
                    :email
                  ],
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  def self.roles_for_collection
    [["Lead Assessor", "lead"], ["Assessor", "regular"]]
  end
end
