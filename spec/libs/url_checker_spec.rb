require File.expand_path('../../spec_helper', __FILE__)

require 'webmock'
include WebMock::API

describe UrlChecker do
  before(:all) do
    @small_image_url = "http://example.com/small_image.jpg"
    @medium_image_url = "http://example.com/medium_image.jpg"
    @huge_image_url = "http://example.com/huge_image.jpg"
    @non_existant = "http://example.com/not_found.jpg"

    WebMock.reset!
    WebMock.enable!
    stub_request(:head, @small_image_url).to_return(:status => ["200", "OK"],:headers => { "Content-Type" => "image/jpeg", "Content-Length" => 100})
    stub_request(:head, @medium_image_url).to_return(:status => ["200", "OK"], :headers => { "Content-Type" => "image/jpeg", "Content-Length" => 1000})
    stub_request(:head, @huge_image_url).to_return(:status => ["200", "OK"], :headers => { "Content-Type" => "image/jpeg", "Content-Length" => 100000000})
    stub_request(:head, @non_existant).to_return(:status => ["404", "Not Found"])
  end

  after(:all) do
    WebMock.reset!
    WebMock.disable!
  end

  it "should validate good image urls" do
      [@small_image_url, @medium_image_url].each do |img|  
        UrlChecker.valid?(img).should be true
        UrlChecker.valid?(img).should be true
      end
  end
  
  it "should not validate good image urls that are too big" do
    UrlChecker.valid?(@huge_image_url,  :max_size => 99999999).should be false
    UrlChecker.valid?(@medium_image_url,:max_size =>100000).should be true
  end
  
  it "should not validate bad image urls" do
    UrlChecker.valid?(@non_existant).should be false
  end
  
end
