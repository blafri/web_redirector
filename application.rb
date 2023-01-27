# frozen_string_literal: true

require "rack"
require "time"

# Application that will redirect naked domains to their www subdomain.
# The request must be to a domain in the urls the object was initialized with or a 403 response will be generated.
# The request must also be a GET request or a 405 response will be generated.
class Application
  attr_reader :urls

  def initialize
    @urls = ENV.fetch("REDIRECT_HOSTS", "").split(",").map(&:strip).map(&:downcase).freeze
  end

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new("", 302, default_headers)

    if valid_request?(request, response)
      response.add_header("Location", "https://www.#{request.host}#{request.fullpath}")
    end

    log_result(request, response)
    response.finish
  end

  private

  def valid_request?(...)
    valid_method(...) && valid_url(...)
  end

  def valid_method(request, response)
    return true if request.get?

    response.status = 405
    false
  end

  def valid_url(request, response)
    return true if urls.include?(request.host.downcase)

    response.status = 403
    false
  end

  def log_result(request, response)
    message = case response.status
              when 405
                "Method was #{request.request_method} which is not supported"
              when 403
                "Host #{request.host} was not found in the list of urls"
              when 302
                "Redirecting #{request.url} to #{response.get_header('Location')}"
              end
    request.logger.info(message)
  end

  def default_headers
    {
      "Content-Type" => "text/html",
      "Date" => Time.now.httpdate
    }
  end
end
