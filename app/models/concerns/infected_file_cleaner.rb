module InfectedFileCleaner
  extend ActiveSupport::Concern

  class_methods do
    def clean_after_scan(*file_attr_names)
      file_attr_names.each do |attr_name|
        override_on_scan_callback(attr_name)
      end
    end

    def override_on_scan_callback(file_attr_name)
      class_eval <<-EVAL, __FILE__, __LINE__+1
        def on_scan_#{file_attr_name}_with_cleanup(params)
          on_scan_#{file_attr_name}_without_cleanup(params)

          if #{file_attr_name}_scan_results == "infected"
            public_send("remove_#{file_attr_name}!")
            save!
          end
        end

        alias_method :on_scan_#{file_attr_name}_without_cleanup, :on_scan_#{file_attr_name}
        alias_method :on_scan_#{file_attr_name}, :on_scan_#{file_attr_name}_with_cleanup
      EVAL
    end
  end
end
