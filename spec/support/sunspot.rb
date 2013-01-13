require 'sunspot/rails/spec_helper'
require 'net/http'

def live? uri
  begin
    Net::HTTP.get_response uri
    true
  rescue Errno::ECONNREFUSED
    false
  end
end

def start_solr timeout=1
  server = Sunspot::Rails::Server.new
  uri = URI.parse("http://0.0.0.0:#{server.port}/solr/")
  if !live?(uri)
    server.start
    at_exit { server.stop }
  end
  while !live?(uri)
    raise "SOLR connection timeout" if timeout.zero?
    sleep 1
    timeout -= 1
  end
  server
end

original_session = nil            # always nil between specs
sunspot_server = nil              # one server shared by all specs

if defined? Spork
  Spork.prefork do
    sunspot_server = start_solr(60) if Spork.using_spork?
  end
end

RSpec.configure do |config|
  config.before(:each) do
    if example.metadata[:solr] # it "...", solr: true do ... to have real SOLR
      sunspot_server ||= start_solr(60)
    else
      original_session = Sunspot.session
      Sunspot.session = Sunspot::Rails::StubSessionProxy.new(original_session)
    end
  end

  config.after(:each) do
    if example.metadata[:solr]
      Sunspot.remove_all!
    else
      Sunspot.session = original_session
    end
    original_session = nil
  end
end
