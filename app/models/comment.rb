class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'Admin', foreign_key: :author_id

  validates :author_id, presence: true
  validates :body, presence: true

  delegate :email, to: :author, prefix: :author
end
