unless ENV["ONLY_ASSETS"]
  PaperTrail::Rails::Engine.eager_load!
  PaperTrail.serializer = PaperTrail::Serializers::JSON
  PaperTrail.config.track_associations = false
end
