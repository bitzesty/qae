if Rack::Utils.respond_to?(:key_space_limit=)
  Rack::Utils.key_space_limit = 131072
end
