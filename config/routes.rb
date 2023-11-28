Rails.application.routes.draw do
  post "/payload" => "webhook#payload"
  post "/gitpayload" => "github#payload"
  # get "/payload" => "webhook#index"
end
