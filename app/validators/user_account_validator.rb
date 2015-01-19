class UserAccountValidator < ActiveModel::Validator
  def validate(record)
    account_id_changes = record.account_id_change
    previous_value = account_id_changes[0]
    new_value = account_id_changes[1]

    if previous_value.present? && new_value.present?
      record.errors.add(:base, "User already associated with another account!")
    elsif previous_value.present? && new_value.blank?
      record.errors.add(:base, "User should be associated with account!")
    end
  end
end