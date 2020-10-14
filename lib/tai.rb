class Tai
  require 'net/http'
  require 'uri'
  require 'json'
  def self.mess mess
    uri = URI.parse("https://wsapi.simsimi.com/190410/talk")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["X-Api-Key"] = ".u7Te8m-mSIJufe35mRyhdpDJD6pt9LZJejMZRVV"
    request.body = JSON.dump({
    "utext" => "#{mess}",
    "lang" => "en"
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