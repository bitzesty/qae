module SharedPdfHelpers::FontHelper
  def set_fonts!
    self.font_families.update(
      "OpenSans" => {
        normal: font_path("OpenSans-Regular.ttf"),
        bold: font_path("OpenSans-Bold.ttf"),
        italic: font_path("OpenSans-RegularItalic.ttf"),
        bold_italic: font_path("OpenSans-BoldItalic.ttf"),
      }
    )

    self.font("OpenSans")
  end

  private

  def font_path(font_name)
    Rails.root.join("app", "assets/fonts", font_name)
  end
end
