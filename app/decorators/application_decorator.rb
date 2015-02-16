class ApplicationDecorator < Draper::Decorator
  delegate_all

  def created_at
    object.created_at.strftime("%b_%d_%Y")
  end

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
