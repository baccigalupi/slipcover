require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Slipcover::Server do
  it "include the Rest module" do
    Slipcover::Database.ancestors.should include(Slipcover::Rest)
  end

  describe '#url' do
    describe 'port' do
      it "does not include the leading colon if a port is not defined" do
        server = Slipcover::Server.new(:domain => 'foo.com')
        server.url.should == "http://foo.com"
      end

      it "includes the port number correctly" do
        server = Slipcover::Server.new(:port => 4444)
        server.url.should == 'http://localhost:4444'
      end
    end

    describe 'username:password' do
      it "includes in correctly" do
        server = Slipcover::Server.new(:user => 'kane', :password => 'secret')
        server.url.should == 'http://kane:secret@localhost'
      end
    end

    describe 'protocol' do
      it "uses the one provided" do
        server = Slipcover::Server.new(:protocol => 'https')
        server.url.should == 'https://localhost'
      end
    end
  end

  describe '.default' do
    before do
      Slipcover::Server.class_eval "@default = nil"
      Slipcover.class_eval "@env = nil"
    end

    after do
      Slipcover::Server.class_eval "@default = nil"
      Slipcover.class_eval "@env = nil"
    end

    it "is determined by the Slipcover environment" do
      Slipcover.env = 'production'
      Slipcover::Server.default.url.should == "https://kane:secret@kane.cloudant.com"
    end

    it "can be set" do
      Slipcover::Server.default = 'http://mycustomserver.com:4567'
      Slipcover::Server.default.url.should == 'http://mycustomserver.com:4567'
    end
  end
end
