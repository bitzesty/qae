Shog.configure do
  if ::Rails.env.production?
    reset_config!
    timestamp
  end

  match /execution expired/ do |msg,matches|
    # Highlight timeout errors
    msg.red
  end
end
