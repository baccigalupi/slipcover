require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Slipcover::Document do
  before :all do
    Slipcover::Database.create(Slipcover.database)
  end

  it "include the Rest module" do
    Slipcover::Document.ancestors.should include(Slipcover::Rest)
  end

  describe '#initialize' do
    before do
      @doc = Slipcover::Document.new
    end

    it "defaults to the default database" do
      @doc.database.should == Slipcover::Database.default
    end

    it "gets an id" do
      @doc.id.should_not be_nil
    end

    it "has a rev of nil" do
      @doc.rev.should == nil
    end

    it "has data" do
      @doc.data.should == {}
    end

    it "can take a data hash" do
      doc = Slipcover::Document.new :foo => 'bar'
      doc.data[:foo].should == 'bar'
    end
  end

  describe '#url' do
    it "is the database url and the name" do
      doc = Slipcover::Document.new
      doc.url.should == "#{doc.database.url}/#{doc.id}"
    end
  end

  describe 'saving' do
    describe 'when new' do
      before do
        @doc = Slipcover::Document.new(:foo => 'bar')
        @response = Hashie::Mash.new({:rev => '123'})
      end

      it "sends a put request to the url" do
        @doc.should_receive(:put).with(nil, anything).and_return(@response)
        @doc.save
      end

      it "sends the correct data" do
        @doc.should_receive(:put) do |path, data|
          data.keys.should =~ ['foo', '_id']
          @response
        end
        @doc.save
      end

      it "updates the returned rev" do
        @doc.save
        @doc.rev.should_not be_nil
      end
    end

    describe 'when updating' do
      before do
        @doc = Slipcover::Document.new(:foo => 'bar').save
        @doc.data['baz'] = 'zardoz'
        @rev = @doc.rev.dup
        @response = Hashie::Mash.new({:rev => '123'})
      end

      it "sends a put request to the url" do
        @doc.should_receive(:put).with(nil, anything).and_return(@response)
        @doc.save
      end

      it "sends the correct data" do
        @doc.should_receive(:put) do |path, data|
          data.keys.should =~ ['foo', 'baz', '_id', '_rev']
          data['_rev'].should == @rev
          @response
        end
        @doc.save
      end

      it "updates the returned rev" do
        @doc.save
        @doc.rev.should_not == @rev
      end
    end
  end

  describe '#reload' do
    before do
      @doc = Slipcover::Document.new(:foo => 'bar').save
      @doc.data['this'] = 'that'
      @response = Hashie::Mash.new({
        :rev => '456',
        :baz => 'zardoz'
      })
    end

    it "sends a get request to the url" do
      @doc.should_receive(:get).and_return(@response)
      @doc.reload
    end

    it "resets the data based on the response" do
      @doc.reload
      @doc.data.keys.should_not include 'this'
    end

    it "updates the rev" do
      @doc.stub(:get).and_return(@response)
      @doc.reload
      @doc.rev.should == '456'
    end

    it "does nothing if the document is new" do
      doc = Slipcover::Document.new(:foo => 'bar')
      doc.reload.should == doc
    end
  end

  describe '#destroy' do
    before do
      @doc = Slipcover::Document.new.save
    end

    it "sends a delete request with the id and revision data" do
      @doc.should_receive(:delete) do |path, data|
        path.should == nil
        data[:_id].should == @doc.id
        data[:_rev].should == @doc.rev
      end
      @doc.destroy
    end
  end

  describe '.uuid' do
    before do
      Slipcover::Document.class_eval "@uuids = []"
    end

    it "requests a new set in the array if the array is empty" do
      Slipcover::Server.default.should_receive(:get).with('_uuids?count=100').and_return(
        {'uuids' => ['foo']}
      )
      Slipcover::Document.uuid
    end

    it "pops off one from the array" do
      Slipcover::Document.uuid.should_not be_nil
      Slipcover::Document.uuids.size.should == 99
    end
  end
end
