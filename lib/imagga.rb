require 'uri'
require 'net/http'

class Imagga
  attr_accessor :tags, :image_url

  def initialize(configs={})
      @image_url = configs[:image_url]
      @tags = nil
  end

  def tag
    url = URI("http://api.imagga.com/v1/tagging?url=" + @image_url + "&version=2")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'
    request["authorization"] = auth_token

    response = http.request(request)
    result = JSON.parse(response.read_body)
    @tags = parse_responses(result)
    puts @tags
  end

  def parse_responses(result)
    tags_to_parse = result['results'][0]['tags']
    tags = {}
    tags_to_parse.each do |tag|
      confidence = tag['confidence'].to_f
      description = tag['tag']
      tags[description] = confidence
    end
    tags
  end

  private

  def auth_token
    ENV["imagga_auth_token"]
  end

end
