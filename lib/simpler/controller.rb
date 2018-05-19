require_relative 'view'

module Simpler
  class Controller
    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'].merge!(@request.params)

      set_default_headers
      send(action)

      write_response

      @response.finish
    end

    def params
      @request.env['simpler.params']
    end

    private

    def change_header(template)
      @response['Content-Type'] = 'text/plain' if template[:plain]
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      renderer = View.render(@request.env)
      renderer.new(@request.env).render(binding)
    end

    def status(code)
      response.status = code
    end

    def header
      @response
    end

    def render(template)
      if template.is_a?(String)
        @request.env['simpler.template'] = template
      else
        change_header(template)
        @request.env['simpler.template_plain'] = template[:plain] if template[:plain]
      end
    end
  end
end
