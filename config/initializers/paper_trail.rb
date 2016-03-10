PaperTrail::Rails::Engine.eager_load! unless ENV["ONLY_ASSETS"]
PaperTrail.serializer = PaperTrail::Serializers::JSON
