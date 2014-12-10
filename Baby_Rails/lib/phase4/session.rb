require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)  
      our_cookies = req.cookies.select { |cookie| cookie.name == "_rails_lite_app" }
      if our_cookies.first
        @cookie_hash = JSON.parse(our_cookies.first.value)
      else
        @cookie_hash = {}
      end
    end

    def [](key)
      @cookie_hash[key]
    end

    def []=(key, val)
      @cookie_hash[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cookie_hash.to_json)
    end
  end
end
