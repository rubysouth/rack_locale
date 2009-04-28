require 'i18n'

module RubySouth

  module I18n

    def self.best_match_for(*locales)
      locales = locales.flatten.compact.uniq
      matches = locales.collect { |l| l.to_sym } & ::I18n.available_locales
      if matches.empty?
        matches = locales.collect { |l| l.to_s.slice(0,2) } & ::I18n.available_locales.map { |l| l.to_s.slice(0,2) }
      end
      (matches.first || ::I18n.default_locale).to_sym
    end

  end

  module Rack

    class Locale

      def initialize(app)
        @app = app
      end

      def call(env)
        request = ::Rack::Request.new(env)
        status, headers, body = @app.call(env)
        headers['Content-Language'] = request.locale.to_s
        response = ::Rack::Response.new(body, status, headers)
        response.set_cookie "locale", { :value => request.locale.to_s, :expires => Time.now + 300_000_000 }
        response.finish
      end

    end

    module Request

      def locale
        @locale ||= I18n.best_match_for(params["locale"], cookies["locale"], accepted_locales)
      end

      def accepted_locales
        return [] if !env["HTTP_ACCEPT_LANGUAGE"]
        env["HTTP_ACCEPT_LANGUAGE"].split(',').collect { |l|
          l.split(';q=')
        }.sort { |x, y|
          (y[1] || 1).to_f <=> (x[1] || 1).to_f
        }.collect { |l|
          l[0].downcase.gsub("-", "_").to_sym
        }
      rescue => error
        puts error.backtrace
        []
      end

    end
  end
end

Rack::Request.class_eval { include RubySouth::Rack::Request }
I18n.class_eval { include RubySouth::I18n }