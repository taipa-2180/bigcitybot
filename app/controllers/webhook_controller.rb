require "chatwork"

class WebhookController < ApplicationController
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
		return if body.include?("[toall]")

		##get name
		sender_name = ChatWork::Member.get(room_id:room_id).find{|member| member["account_id"]==from_account_id}.name

		##message
		message = "[To:#{from_account_id}]#{sender_name}\n" + body.slice(body.index("\n")+1, body.size)

		ChatWork::Message.create room_id: room_id, body: message
	end

	# private

	def load_chatwork
    ChatWork.api_key = ENV["CHATWORK_API_TOKEN"]
  end
end
