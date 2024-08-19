module SharedPdfHelpers::LanguageHelper
  def set_language!
    state.store.root.data[:Lang] = "en-UK"
  end
end
