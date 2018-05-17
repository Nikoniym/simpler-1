require 'erb'

module Simpler
  class View
    class HtmlRender
      VIEW_BASE_PATH = 'app/views'.freeze

      def initialize(env)
        @env = env
      end

      def render(binding)
        template = File.read(template_path)

        ERB.new(template).result(binding)
      end

      def params

      end

      private

      def controller
        @env['simpler.controller']
      end

      def action
        @env['simpler.action']
      end

      def template
        @env['simpler.template']
      end

      def template_path
        path = template || [controller.name, action].join('/')
        @env['simpler.render_view'] = "#{path}.html.erb"
        Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
      end
    end
  end
end
