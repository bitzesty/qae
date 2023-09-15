module Reviewable
  extend ActiveSupport::Concern

  included do
    belongs_to :reviewable, polymorphic: true, optional: true

    validates :reviewable_type,
              :reviewable_id,
              :reviewed_at,
              presence: true,
              if: :reviewed?

  end

  def reviewed?
    reviewed_at.present?
  end
end
