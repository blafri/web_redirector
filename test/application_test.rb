# frozen_string_literal: true

require "rack/test"
require "application"

class ApplicationTest < Minitest::Test
  include Rack::Test::Methods

  def app
    return @app unless @app.nil?

    ENV.stub(:fetch, "foo.com, bar.com") do
      @app = Rack::Builder.load_file("config.ru")
    end
  end

  def test_app_returns_405_if_request_is_not_a_get_request
    post("/")

    assert_same(405, last_response.status)
  end

  def test_app_returns_403_if_host_is_not_in_urls_constant
    get("/", "", "HTTP_HOST" => "not-gonna-match.com")

    assert_same(403, last_response.status)
  end

  def test_app_redirects_to_www_if_url_matches_and_is_get_request
    get("/", "", "HTTP_HOST" => "foo.com")

    assert_same(302, last_response.status)
    assert_equal("https://www.foo.com/", last_response.headers["location"])

    get("/", "", "HTTP_HOST" => "bar.com")

    assert_same(302, last_response.status)
    assert_equal("https://www.bar.com/", last_response.headers["location"])
  end

  def test_app_redirects_to_www_if_url_matches_and_is_get_request_case_insensitivly
    get("/", "", "HTTP_HOST" => "FOO.com")

    assert_same(302, last_response.status)
    assert_equal("https://www.FOO.com/", last_response.headers["location"])
  end
end
