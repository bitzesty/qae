class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :authorable, polymorphic: true, optional: true

  validates :body, presence: true

  delegate :email, to: :authorable, prefix: :author

  enum section: {
    admin: 0, # only Admin can edit/see
    critical: 1 # Admin & Assessors can edit/see
  }

  def author?(subject)
    authorable == subject
  end

  def author
    authorable_type.constantize.unscoped.where(id: authorable_id).first
  end

  def self.admin
    where(section: 0).order(created_at: :desc)
  end

  def self.critical
    where(section: 1).order(created_at: :desc)
  end

  def self.flagged
    where(flagged: true).order(created_at: :desc)
  end
end
