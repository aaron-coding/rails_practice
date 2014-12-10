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
    # this returns a deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      parsed_set = URI.decode_www_form(www_encoded_form)
      parsed_set.each do |key, val| 
          key_set = parse_key(key)  #Create array from keys  
          current = @params         #Set params and modify it while iterating
          key_set[0..-2].each do |key|
            current[key] ||= {}     #make a new hash if not existing
            current = current[key]  #reference hash within the params
          end
          current[key_set[-1]] = val  #assign value to last key
      end
    end

    # this returns an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
