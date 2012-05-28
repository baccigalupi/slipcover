require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Slipcover::Database do
  before do
    @server = Slipcover::Server.default
    @server.delete('name') rescue nil
  end

  describe '#server' do
    it "is the default unless otherwise specified" do
      Slipcover::Database.default.server.should == @server
    end

    it "can be something else" do
      server = Slipcover::Server.new(:domain => 'foo.com')
      db = Slipcover::Database.new('foo', :server => server)
      db.server.should == server
    end
  end

  describe '#default' do
    after do
      @server.delete('slipcover_test')
    end

    it "is what is specified in the config" do
      Slipcover::Database.default.url.should == "#{Slipcover::Server.default.url}/slipcover_test"
    end
  end

  describe '#create' do
    it "makes a new database on the server" do
      Slipcover::Database.create('name')
      @server.get('_all_dbs').should include('name')
    end

    it "returns a database object" do
      Slipcover::Database.create('name').class.should == Slipcover::Database
    end

    describe 'when the database already exists' do
      before do
        Slipcover::Database.create('name')
      end

      it "does not throw an error" do
        lambda {
          Slipcover::Database.create('name')
        }.should_not raise_error
      end

      it "returns the database object" do
        Slipcover::Database.create('name').class.should == Slipcover::Database
      end
    end
  end

  it '#url includes the host and name' do
    Slipcover::Database.create('name').url.should == "#{Slipcover::Server.default.url}/name"
  end

  it "#destroy will send a delete with the database url" do
    db = Slipcover::Database.create('name')
    RestClient.should_receive(:delete).with(db.url)
    db.destroy
  end

  it "include the Rest module" do
    Slipcover::Database.ancestors.should include(Slipcover::Rest)
  end
end

