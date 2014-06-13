require 'faraday'
require 'faraday_middleware'

module Tumblr
  module Connection

    def connection(options={})
      
      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => "tumblr_client (ruby) - #{Tumblr::VERSION}"
        },
        :url => "http://#{api_host}/"
      }

      #client = options[:client] ||= Faraday.default_adapter

      Faraday.new("http://#{api_host}/", default_options.merge(options)) do |faraday|
        data = { :api_host => api_host }.merge(credentials)
        unless credentials.empty?
          faraday.request :oauth, data
        end

        faraday.request  :multipart
        faraday.request  :url_encoded
        faraday.response :json, :content_type => /\bjson$/
        faraday.adapter  Faraday.default_adapter
      end
    end

  end
end
