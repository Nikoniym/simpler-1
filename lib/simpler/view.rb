require_relative 'render/html_render'
require_relative 'render/text_render'

module Simpler
  class View
    def self.render(env)
      if env['simpler.template_plain']
        TextRender
      else
        HtmlRender
      end
    end
  end
end
