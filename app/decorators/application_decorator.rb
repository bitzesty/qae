class ApplicationDecorator < Draper::Decorator
  delegate_all

  def created_at
    object.created_at.strftime("%b_%d_%Y")
  end

  def created_at_timestamp
    object.created_at.strftime("%d%m%Y_%H%M")
  end

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
