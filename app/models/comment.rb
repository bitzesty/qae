class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :authorable, polymorphic: true

  validates :body, presence: true

  delegate :email, to: :authorable, prefix: :author

  def author?(subject)
    authorable == subject
  end
end
