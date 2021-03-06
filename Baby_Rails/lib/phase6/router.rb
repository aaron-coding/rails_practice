module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern, @http_method = pattern, http_method
      @controller_class, @action_name = controller_class, action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      !!(req.path =~ @pattern) && req.request_method.downcase.to_sym == http_method
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      saved_hash = {}
      match_data = pattern.match(req.path)
      if !(match_data.captures.empty?)
        match_data.names.each do |name|
            saved_hash[name] = match_data[name]
        end
        controller_class.new(req, res, saved_hash).invoke_action(action_name)
      else
        controller_class.new(req, res).invoke_action(action_name)
      end
    end
    
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      @routes += [Route.new(pattern, method, controller_class, action_name)]
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      self.instance_eval &proc 
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method.to_s) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name)
      end

    end

    # should return the route that matches this request
    def match(req)
      matching_routes = @routes.select { |route| route.matches?(req) }
      return nil if matching_routes.empty?
      matching_routes.first #refactor later to throw error if 2 matching routes
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      return res.status = 404 unless match(req)
      match(req).run(req, res)
    end
  end
end
