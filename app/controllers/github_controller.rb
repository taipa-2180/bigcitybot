require "chatwork"
require 'uri'
# require 'httparty'

class GithubController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :load_chatwork, only: :payload

  def payload
    pr_url        = payload_params["comment"]["html_url"]
    pr_comment    = payload_params["comment"]["body"]
    pr_commenter  = payload_params["comment"]["user"]["login"]
    binding.pry
    full_message = "[To: >>TOALL]#{pr_commenter}\n commented:" + pr_comment
    ChatWork::Message.create room_id: room_id, body: full_message
  end

  private

  def load_chatwork
    ChatWork.api_key = "7711e7678122b201097ce3b70df13192"
  end

  def room_id
    "7057636"
  end

  def payload_params
    JSON.parse(params[:payload])
  end
end
