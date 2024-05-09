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
    user = klass.capitalize.constantize.find_by(id: id)

    # if user is destroyed we don't update versions' whodunnit keys
    # this helps to avoid 404 errors on the application page
    # and display "N/A" for such users
    if user
      user.decorate.full_name
    else
      nil
    end
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
      if version.whodunnit && whodunnit_hash[version.whodunnit]
        whodunnit_hash[version.whodunnit]
      else
        "N/A"
      end
    end
  end
end
