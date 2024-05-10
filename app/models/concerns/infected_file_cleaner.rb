module InfectedFileCleaner
  extend ActiveSupport::Concern

  class_methods do
    def clean_after_scan(*file_attr_names)
      file_attr_names.each do |attr_name|
        override_on_scan_callback(attr_name)
      end
    end

    def override_on_scan_callback(file_attr_name)
      class_eval <<-EVAL, __FILE__, __LINE__ + 1
        def on_scan_#{file_attr_name}_with_cleanup(params)
          on_scan_#{file_attr_name}_without_cleanup(params)

          if #{file_attr_name}_scan_results == "infected"
            public_send("remove_#{file_attr_name}!")
            save!
          end
        end

        # scan_file! method is called in check_scan_file after commit callback
        # if the file is infected it gets deleted, then AR model is saved again
        # in order to avoid sending a scanning request without the file
        # we're adding a check to see if it's present or not
        # scan_file_with_cleanup! is an alias new method that gets called with scan_file!
        # scan_file_without_cleanup! is calling to the unmodified gem's code

        def scan_#{file_attr_name}_with_cleanup!
          return unless #{file_attr_name}.present?

          scan_#{file_attr_name}_without_cleanup!
        end

        alias_method :scan_#{file_attr_name}_without_cleanup!, :scan_#{file_attr_name}!
        alias_method :scan_#{file_attr_name}!, :scan_#{file_attr_name}_with_cleanup!

        alias_method :on_scan_#{file_attr_name}_without_cleanup, :on_scan_#{file_attr_name}
        alias_method :on_scan_#{file_attr_name}, :on_scan_#{file_attr_name}_with_cleanup
      EVAL
    end
  end
end
