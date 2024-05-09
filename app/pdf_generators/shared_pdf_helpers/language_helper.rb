module SharedPdfHelpers::LanguageHelper
  def set_language!
    self.state.store.root.data[:Lang] = "en-UK"
  end
end
