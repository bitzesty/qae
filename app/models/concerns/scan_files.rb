module ScanFiles
  extend ActiveSupport::Concern

  included do
    before_save :set_scan_results_to_pending
    after_commit :perform_virus_scan, on: [:create, :update]
  end

  def perform_virus_scan
    self.class.file_attributes_to_scan.each do |attr_name|
      file = send(attr_name)
      next if file.blank?

      key = { model: self.class.name, column: attr_name, id: id }.to_json
      FileScanJob.perform_later(key, self.class.name, id, attr_name)
    end
  end

  private

  def move_to_clean_bucket(attr_name)
    file = send(attr_name)
    if file.present?
      if Rails.env.production? || ENV["ENABLE_VIRUS_SCANNER_BUCKETS"] == "true"
        move_to_permanent_s3_bucket(file)
      else
        move_to_permanent_local_folder(attr_name)
      end
      Rails.logger.info("File moved to clean storage: #{self.class.name} ID #{id}, #{attr_name}")
    end
  end

  def move_to_permanent_s3_bucket(file)
    tmp_bucket_s3_client = Aws::S3::Client.new({
      region: ENV["AWS_REGION"],
      access_key_id: ENV["AWS_TMP_BUCKET_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_TMP_BUCKET_SECRET_ACCESS_KEY"],
    })
    clean_bucket_s3_client = Aws::S3::Client.new({
      region: ENV["AWS_REGION"],
      access_key_id: ENV["AWS_PERMANENT_BUCKET_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_PERMANENT_BUCKET_SECRET_ACCESS_KEY"],
    })

    object_to_copy = tmp_bucket_s3_client.get_object(
      bucket: ENV["AWS_S3_TMP_BUCKET"],
      key: file.path,
    )

    clean_bucket_s3_client.put_object(
      bucket: ENV["AWS_S3_PERMANENT_BUCKET"],
      body: object_to_copy.body.read,
      key: file.permanent_path,
    )

    tmp_bucket_s3_client.delete_object(
      bucket: ENV["AWS_S3_TMP_BUCKET"],
      key: file.path,
    )
  end

  def move_to_permanent_local_folder(attribute_name)
    file = send(attribute_name)
    if file.respond_to?(:path)
      new_path = file.path.sub("/tmp/", "/permanent/")
      Rails.logger.debug "Moving file from #{file.path} to #{new_path}"
      FileUtils.mkdir_p(File.dirname(new_path))
      FileUtils.mv(file.path, new_path) unless File.exist?(new_path)
      file.instance_variable_set(:@path, new_path)
      Rails.logger.debug "File moved successfully. New path: #{file.path}"
    else
      Rails.logger.debug "File not present for #{attribute_name}"
    end
  end

  class_methods do
    def scan_for_viruses(*file_attr_names)
      @file_attributes_to_scan = file_attr_names
      file_attr_names.each do |attr_name|
        define_scan_method(attr_name)
        define_clean_after_scan_method(attr_name)
        define_clean_method(attr_name)
        define_set_scan_results_to_pending_method(attr_name)
      end
    end

    def file_attributes_to_scan
      @file_attributes_to_scan || []
    end

    private

    def define_scan_method(file_attr_name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def scan_#{file_attr_name}!
          return unless #{file_attr_name}.present? && #{file_attr_name}.file.present?

          if ENV['DISABLE_VIRUS_SCANNER'] == 'true'
            update_column('#{file_attr_name}_scan_results', 'clean')
            move_to_clean_bucket(:#{file_attr_name})
            return true
          end
          
          key = { model: self.class.name, column: '#{file_attr_name}', id: id }.to_json
          FileScanJob.perform_later(key, self.class.name, id, '#{file_attr_name}')
          
          update_column('#{file_attr_name}_scan_results', 'scanning')
          true
        end

        after_commit :check_scan_#{file_attr_name}, on: [:create, :update]

        def check_scan_#{file_attr_name}
          scan_#{file_attr_name}! if #{file_attr_name}_changed?
        end
      RUBY
    end

    def define_clean_after_scan_method(file_attr_name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def on_scan_#{file_attr_name}(params)
          if params[:status] == 'clean'
            move_to_clean_bucket(:#{file_attr_name})
            update_column('#{file_attr_name}_scan_results', 'clean')
          elsif params[:status] == 'infected'
            update_column('#{file_attr_name}_scan_results', 'infected')
            Rails.logger.warn("Infected file detected: \#{self.class.name} ID \#{id}, #{file_attr_name}")
          else
            update_column('#{file_attr_name}_scan_results', params[:status])
          end
        end
      RUBY
    end

    def define_clean_method(file_attr_name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def clean?
          #{file_attr_name}_scan_results == "clean"
        end
        def pending_or_scanning?
          #{file_attr_name}_scan_results == "pending" || #{file_attr_name}_scan_results == "scanning"
        end
        def infected?
          #{file_attr_name}_scan_results == "infected"
        end
      RUBY
    end

    def define_set_scan_results_to_pending_method(file_attr_name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def set_scan_results_to_pending
          self.#{file_attr_name}_scan_results = 'pending' if #{file_attr_name}_changed?
        end
      RUBY
    end
  end
end
