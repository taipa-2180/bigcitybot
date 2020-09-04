Rails.application.routes.draw do
  post "/payload" => "webhook#payload"
  # get "/payload" => "webhook#index"
end
