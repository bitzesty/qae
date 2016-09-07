class FormAnswerVersionsDispatcher
  def initialize(form_answer)
    @form_answer = form_answer
  end

  def versions
    @form_answer.versions.map do |version|
      Version.new(version, whodunnit_hash)
    end
  end

  private

  def whodunnit_hash
    @whodunnit_hash ||= begin
      keys = @form_answer.versions.map(&:whodunnit).uniq.compact
      Hash[keys.map { |key| [key, get_full_name(key)] }]
    end
  end

  def get_full_name(whodunnit_key)
    klass, id = whodunnit_key.split(":")
    klass.capitalize.constantize.find(id).decorate.full_name
  end

  class Version
    attr_reader :version, :whodunnit_hash

    def initialize(version, whodunnit_hash)
      @version = version
      @whodunnit_hash = whodunnit_hash
    end

    def event
      "#{version.event.capitalize}d"
    end

    def created_at
      version.created_at.strftime("%d/%m/%Y at %H:%M")
    end

    def whodunnit
      return "N/A" unless version.whodunnit
      whodunnit_hash[version.whodunnit]
    end
  end
end
