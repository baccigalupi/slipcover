require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Slipcover::Database do
  before do
    Slipcover.delete('name') rescue nil
  end

  describe '#default' do
    after do
      Slipcover.delete(Slipcover.database)
    end

    it "is what is specified in the config" do
      Slipcover::Database.default.url.should == "#{Slipcover.url}/slipcover_test"
    end
  end

  describe '#create' do
    it "makes a new database on the server" do
      Slipcover::Database.create('name')
      Slipcover.get('_all_dbs').should include('name')
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
    Slipcover::Database.create('name').url.should == "#{Slipcover.url}/name"
  end

  it "#destroy will send a delete with the database url" do
    db = Slipcover::Database.create('name')
    RestClient.should_receive(:delete).with(db.url)
    db.destroy
  end

  describe 'REST' do
    it 'uses the url' do
      db = Slipcover::Database.create('name')
      RestClient.should_receive(:get).with("#{db.url}/something")
      db.get "something"
    end
  end
end

