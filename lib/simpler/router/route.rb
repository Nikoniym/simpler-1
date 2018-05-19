module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(env)
        method = env['REQUEST_METHOD'].downcase.to_sym
        path = env['PATH_INFO']

        @method == method && path_comparison(path, env)
      end

      def params
        @params
      end

      private

      def path_comparison(path, env)
        path = path.split('?').first  if path.include?('?')
        @params = {}
        request_path = path.split('/')
        route_path = @path.split('/')

        request_path.zip(route_path).each do |element_request_path, element_route_path|
          return false if element_route_path.nil?

          if element_route_path.include?(':')
            key = element_route_path.delete(':').to_sym
            @params[key] = element_request_path
          else
            element_route_path == element_request_path ? true : (return false)
          end
        end
      end
    end
  end
end
