module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req, @res = req, res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @already_built_response || false 
    end

    # Set the response status code and header
    def redirect_to(url)
      unless already_built_response?
        @res.status = 302
        @res.header['location'] = url
      else
        raise "Content already rendered"  
      end
      @already_built_response = true
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(body_content, content_type)
      unless already_built_response?
        @res.content_type = content_type
        @res.body = body_content
      else
        raise "Content already rendered"
      end
      @already_built_response = true
    end
  end
end
