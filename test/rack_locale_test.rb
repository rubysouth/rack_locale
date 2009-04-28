require 'rubygems'
require 'mocha'
require 'test/unit'
require 'rack'
require File.dirname(__FILE__) + "/../lib/rack_locale.rb"

Rack::MockRequest.class_eval { include RubySouth::Rack::Request }

class RackLocaleTest < Test::Unit::TestCase
  
  def test_accepted_locales_with_one_language
    request = make_request("HTTP_ACCEPT_LANGUAGE" => "en-us")
    assert_equal [:en_us], request.accepted_locales
  end
  
  def test_accepted_locales_with_no_header_returns_empty_array
    request = make_request
    assert_equal [], request.accepted_locales
  end
  
  
  def test_accepted_locales_with_multiple_locales_should_have_correct_order
    request = make_request("HTTP_ACCEPT_LANGUAGE" => "en-us,en;q=0.8,es;q=0.3,es-ar;q=0.5")
    assert_equal [:en_us, :en, :es_ar, :es], request.accepted_locales
  end
  
  def test_request_locale_returns_highest_priority
    I18n.stubs(:available_locales).returns([:en_us, :es_ar])
    request = make_request("HTTP_ACCEPT_LANGUAGE" => "es-ar;q=0.9,en;q=0.8,es;q=0.3,es-ar;q=0.5")
    assert_equal :es_ar, request.locale
  end
  
  def test_request_locale_returns_highest_available_priority
    I18n.stubs(:available_locales).returns([:en, :pt_br])
    request = make_request("HTTP_ACCEPT_LANGUAGE" => "es-ar;q=0.9,en-au;q=0.8,es;q=0.3,es-ar;q=0.5")
    assert_equal :en, request.locale
  end

  def test_param_is_the_highest_priority
    I18n.stubs(:available_locales).returns([:en, :pt_br])
    request = make_request("HTTP_ACCEPT_LANGUAGE" => "en,pt_br", "QUERY_STRING" => "locale=pt_br", "HTTP_COOKIE" => "locale=en")
    assert_equal :pt_br, request.locale
  end

  def test_cookie_is_the_second_highest_priority
    I18n.stubs(:available_locales).returns([:en, :pt_br])
    request = make_request("HTTP_ACCEPT_LANGUAGE" => "en,pt_br", "HTTP_COOKIE" => "locale=pt_br")
    assert_equal :pt_br, request.locale
  end
  
  private
  
  def make_request(opts = {})
    Rack::Request.new(Rack::MockRequest.env_for("http://example.com:8080/", opts))
  end

end
