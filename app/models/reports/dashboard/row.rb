class Reports::Dashboard::Row
  attr_reader :label, :content

  def initialize(label, content)
    @label = label
    @content = content
  end
end
