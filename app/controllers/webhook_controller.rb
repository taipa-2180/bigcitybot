require "chatwork"
require 'uri'
# require 'httparty'

class WebhookController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :load_chatwork, only: [:index, :payload]

  def index
  end

  def payload
    from_account_id = params[:webhook_event][:from_account_id]
    to_account_id = params[:webhook_event][:to_account_id]
    room_id = params[:webhook_event][:room_id]
    message_id = params[:webhook_event][:message_id]
    body = params[:webhook_event][:body]
    return if from_account_id.nil?

    ##get name
    sender_name = ChatWork::Member.get(room_id:room_id).find{|member| member["account_id"]==from_account_id}.name

    message = body.slice(body.index("\n")+1, body.size)

    ### Simsimi
    simsimi_reply = mess(message)
    simsimi_reply = "ToAll thì chừa tao ra (tat8)!"  if body.include?("[toall]")
    simsimi_reply = "Nói nhảm cái gì thế? (???)" if body == ""
    simsimi_reply = "Tài thì đẹp try rồi (yaoming)" if body.include?("Tài") && body.include?(" ai")
    ##message 
     
    # full_message = "[Trả lời aid=#{from_account_id} to=#{room_id}-#{message_id}]#{sender_name}\n" + simsimi_reply
    full_message = "[To:#{from_account_id}]#{sender_name}\n" + simsimi_reply
    
    ChatWork::Message.create room_id: room_id, body: full_message
  end

  # private

  def load_chatwork
    ChatWork.api_key = "575aa440fed4f205b88426024c0730a4"
  end

  def mess mess
    uri = URI.parse("https://wsapi.simsimi.com/190410/talk")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["X-Api-Key"] = "YPeRItijS3ACaQPQIrdcLo_p7VKIlYdmAAwkmzAv"
    request.body = JSON.dump({
    "utext" => "#{mess}",
    "lang" => "vi"
    })

    req_options = {
    use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    res = JSON.parse response.body
    res["atext"]
  end 
end
