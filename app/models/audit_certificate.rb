class AuditCertificate < ActiveRecord::Base
  mount_uploader :attachment, AuditCertificateUploader

  begin :associations
    belongs_to :form_answer
  end

  begin :validations
    validates :form_answer_id, uniqueness: true,
                               presence: true
    validates :attachment, presence: true,
                           file_size: {
                             maximum: 25.megabytes.to_i
                           }
  end
end
