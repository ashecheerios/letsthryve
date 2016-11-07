class SendMessageService

  def initialize(sender_id)
    @sender_id = sender_id
  end

  def message(message, data_hash={})
    data = {
      recipient: {id: @sender_id},
      message: {text: I18n.t(message, data_hash)}
    }
    send_it(data)
  end

  private

  def send_it(data)
    RestClient.post "https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV['PAGE_ACCESS_TOKEN']}",
                    data.to_json, content_type: :json
  end

end