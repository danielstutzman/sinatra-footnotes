require 'sinatra-footnotes/version'
require 'sinatra/base'

module Sinatra
  module Footnotes
    IGNORED_IVARS = %w[
      @default_layout
      @app
      @template_cache
      @env
      @request
      @response
      @params
    ]

    module Helpers
      def html_for_instance_variables
        ivars = instance_variables - IGNORED_IVARS.map { |ivar| ivar.intern }
        list_items = ivars.map { |ivar| "<li>#{ivar}</li>\n" }
        (["<hr>", "Instance vars", "<ul>"] + list_items + ["</ul>"]).join("\n")
      end

      def html_for_params
        htmls = []
        htmls.push "<hr>"
        htmls.push "Params:"
        htmls.push "<ul>"
        params.each do |name, value|
          htmls.push "<li>#{name}=#{value}</li>"
        end
        htmls.push "</ul>"
        htmls.join("\n")
      end
    end

    def self.registered(app)
      app.helpers Footnotes::Helpers

      app.after do
        response.body.push html_for_instance_variables
        response.body.push html_for_params
      end
    end
  end

  register Footnotes
end
