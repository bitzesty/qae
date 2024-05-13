module FormattedTime::DateTimeFor
  extend ActiveSupport::Concern

  module ClassMethods
    def formatted_time_for(*attrs)
      mod = Module.new do
        attrs.each do |attr|
          define_method("formatted_#{attr}=") do |value|
            hours, min = value.match(/(\d{2}):(\d{2})/).try(:captures)

            seconds = if hours && min
              hours.to_i * 3600 + min.to_i * 60
            end

            self.public_send("#{attr}=", seconds)
          end

          define_method("formatted_#{attr}") do
            seconds = public_send(attr)

            if seconds
              hours, minutes = seconds.divmod(3600)
              "%02d:%02d" % [hours, (minutes / 60)]
            end
          end
        end
      end

      include mod
    end

    def formatted_date_for(*attrs)
      mod = Module.new do
        attrs.each do |attr|
          attr_accessible "formatted_#{attr}" if respond_to?(:attr_accessible)

          define_method("formatted_#{attr}=") do |value|
            date = begin
              Date.strptime(value, "%d/%m/%Y")
            rescue
              nil
            end
            self.public_send("#{attr}=", date)
          end

          define_method("formatted_#{attr}") do
            date = public_send(attr)
            date && date.strftime("%d/%m/%Y")
          end
        end
      end

      include mod
    end

    def date_time_for(*attrs)
      attrs.each do |attr|
        date = :"#{attr}_date"
        time = :"#{attr}_time"

        attr_accessible "formatted_#{date}", "formatted_#{time}" if respond_to?(:attr_accessible)

        formatted_time_for time
        formatted_date_for date

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{date}
            value = #{attr}
            if value
              value = value.in_time_zone(Time.zone)
              value.to_date
            end
          end

          def #{time}
            value = #{attr}
            if value
              value = value.in_time_zone(Time.zone)

              value.to_i - value.beginning_of_day.to_i
            end
          end

          def #{date}=(value)
            if #{attr}
              seconds = #{attr}.hour.hours + #{attr}.min.minutes
            end

            if value
              zone = Time.zone
              self.#{attr} = zone.local(value.year, value.month, value.day)

              self.#{attr} += seconds if #{attr} && seconds
            else
              self.#{attr} = nil
            end
          end

          def #{time}=(value)
            time = if #{date}
              Time.zone.local(#{date}.year, #{date}.month, #{date}.day)
            else
              nil
            end

            self.#{attr} = time.to_time + value if time && value
          end
        RUBY
      end
    end
  end
end
