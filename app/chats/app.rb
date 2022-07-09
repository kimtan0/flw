class App
  require 'pubnub'

  def pubchat
    pubnub = Pubnub.new(
      subscribe_key: :"sub-c-c8723627-07b7-4f78-9658-ccc6d78723db",
      publish_key: :"pub-c-6c775362-cd2d-4b19-a805-6953eff53cb3",
      uuid: :"3029d4eb-51c1-4679-b6ff-515725d0667c"
    )

    callback = Pubnub::SubscribeCallback.new(
    message: ->(envelope) { puts "MESSAGE: # {puts envelope.result[:data][:message]['msg']}"},
    presence: ->(envelope) { puts "PRESENCE: #{envelope.result[:data]}"}
    )

    pubnub.add_listener(callback: callback)
  end

end