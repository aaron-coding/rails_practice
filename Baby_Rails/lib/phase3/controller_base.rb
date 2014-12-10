require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    def render(template_name)
      # This looks at the file called "views/CONTROLLER/template_name.html.erb"
      # it will create that into an instance of ERB and then render it with
      # all instance variables available.
      template = ERB.new(
      File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
      )
      render_content(template.result(binding), "text/html")
    end
  end
end
