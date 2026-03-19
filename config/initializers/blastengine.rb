require "blastengine"

Blastengine.initialize(
  api_key: ENV["BLASTENGINE_API_KEY"],
  user_name: ENV["BLASTENGINE_USER_ID"]
)
