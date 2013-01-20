require 'sunspot/rails'
require 'net/http'

module SolrTestServer
  extend self

  @server = nil
  @stubbed = false

  def server
    @server ||= Sunspot::Rails::Server.new
  end

  def stub
    unless @stubbed
      Sunspot.session = Sunspot::Rails::StubSessionProxy.new(current_session)
      @stubbed = true
    end
  end

  def unstub
    if @stubbed
      Sunspot.session = current_session
      @stubbed = false
    end
  end

  def start timeout = 1
    unstub
    unless running?
      server.start
      timeout.times { sleep 0.1 }
      raise "Failed to connect to Solr server at #{Sunspot.session.config.solr.url} after #{timeout} seconds!" unless running?
      at_exit { server.stop }
    end
  end

  private

  def current_session
    @session || Sunspot.session
  end

  def running?
    begin
      Net::HTTP.get_response URI.parse("#{Sunspot.session.config.solr.url}/solr/")
      true
    rescue Errno::ECONNREFUSED
      false
    end
  end

end
