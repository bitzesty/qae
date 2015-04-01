class PreviousWinDecorator < ApplicationDecorator
  def category_name
    PreviousWin::CATEGORIES.invert[object.category]
  end

  def description
    "#{category_name} - #{object.year}".strip
  end
end
