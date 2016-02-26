require 'sinatra/base'
require 'json'

module Condfig
  class Api < Sinatra::Base
    configure do
      set :show_exceptions, false
    end

    before do
      content_type :json
    end

    get '/pages' do
      hrefs = {}
      ConfigRepository.all.map do |k|
        hrefs[k] = { href: location_for(k) }
      end
      etag Digest::MD5.hexdigest(hrefs.to_s)
      hrefs.to_json
    end

    get '/pages/:id' do
      data = ConfigRepository.search(params[:id])
      return 404 unless data

      etag Digest::MD5.hexdigest(data)
      data
    end

    put '/pages/:id' do
      begin
        return status 404 unless ConfigRepository.search(params[:id])

        payload = JSON.parse(request.body.read)
        data    = PageConfig.new(payload)

        if data.valid?(id: params[:id])
          ConfigRepository.store(data.id, data.as_json)
          data.as_json
        else
          status 400
        end
      rescue JSON::ParserError
        status 400
      end
    end

    post '/pages' do
      begin
        payload = JSON.parse(request.body.read)
        return status 409 if ConfigRepository.search(payload['id'])

        data = PageConfig.new(payload)

        if data.valid?(id: payload['id'])
          ConfigRepository.store(data.id, data.as_json)
          [201, { 'location' => location_for(data.id) }, nil]
        else
          status 400
        end
      rescue JSON::ParserError
        status 400
      end
    end

    delete '/pages/:id' do
      if ConfigRepository.search(params[:id])
        ConfigRepository.remove(params[:id])
        status 204
      else
        status 404
      end
    end

    get '/ping' do
      ConfigRepository.ping
    end

    private

    def location_for(id)
      [request.base_url, 'pages', id].join('/')
    end
  end
end
