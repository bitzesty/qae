namespace :vigilion_migration do
  desc "copies old VirusScans information into Vigilion columns"
  task convert_to_vigilion: :environment do
    ActiveRecord::Base.connection.execute <<-EOS
      UPDATE form_answer_attachments
      SET file_scan_results=scans.status
      FROM (select * from scans) as scans
      WHERE form_answer_attachments.id = scans.form_answer_attachment_id
    EOS

    ActiveRecord::Base.connection.execute <<-EOS
      UPDATE audit_certificates
      SET attachment_scan_results=scans.status
      FROM (select * from scans) as scans
      WHERE audit_certificates.id = scans.audit_certificate_id
    EOS

    ActiveRecord::Base.connection.execute <<-EOS
      UPDATE support_letter_attachments
      SET attachment_scan_results=scans.status
      FROM (select * from scans) as scans
      WHERE support_letter_attachments.id = scans.support_letter_attachment_id
    EOS
  end
end
