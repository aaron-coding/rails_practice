require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
       @params = {}
       if req.query_string
         parse_www_encoded_form(req.query_string)
       end
       if req.body
         parse_www_encoded_form(req.body)
       end
       if !(route_params.empty?)
         route_params.each do |k,v|
           @params[k] = v
         end
       end
    end

    def [](key)
      @params[key.to_s] #this makes symbols process identically to strings
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      _query = URI.decode_www_form(www_encoded_form)
      _query.each do |key, val|
        if parse_key(key).count == 1
          @params[key] = val
        else
          nested_hash = {}
          all_keys = parse_key(key)
          first = true
          all_keys.reverse.each do |key|  # build a nested hash
            if first                      # First assign value
              nested_hash[key] = val      
            else
              new_hash = {}               # put it into a nested hash
              new_hash[key] = nested_hash # until iterate through all 
              nested_hash = new_hash      # parts
            end
            first = false
          end
          @params = nested_hash
        end
      end
      
    end

    # this returns an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
