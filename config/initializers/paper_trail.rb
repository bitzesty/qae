unless ENV["ONLY_ASSETS"]
  PaperTrail::Rails::Engine.eager_load!
  PaperTrail.serializer = PaperTrail::Serializers::JSON
end
