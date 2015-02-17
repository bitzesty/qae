class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :author_id, presence: true
  validates :body, presence: true
end
