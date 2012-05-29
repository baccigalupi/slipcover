require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Slipcover::Rest do
  before :all do
    class MyClass
      extend Slipcover::Rest
      def self.url
        "http://my-url.com"
      end
    end
  end

  it "gets" do
    RestClient.should_receive(:get).with("#{MyClass.url}/foo")
    MyClass.get('foo')
  end

  it "posts" do
    RestClient.should_receive(:post).with("#{MyClass.url}/foo", anything)
    MyClass.post('foo')
  end

  it "posts with data" do
    RestClient.should_receive(:post).with(anything, {:data => 'you know it!'}.to_json)
    MyClass.post('foo', {:data => 'you know it!'})
  end

  it "puts" do
    RestClient.should_receive(:put).with("#{MyClass.url}/foo", anything)
    MyClass.put('foo')
  end

  it "puts with data" do
    RestClient.should_receive(:put).with(anything, {:data => 'yeah!'}.to_json)
    MyClass.put('foo', {:data => 'yeah!'})
  end

  it "deletes" do
    RestClient.should_receive(:delete).with("#{MyClass.url}/foo")
    MyClass.delete('foo')
  end

  describe 'response' do
    it "parses the json" do
      RestClient.should_receive(:put).and_return({one: 'way'}.to_json)
      MyClass.put.should == {'one' =>'way'}
    end

    it "returns the direct response if that raises an error" do
      RestClient.should_receive(:get).and_return('0 this')
      JSON.should_receive(:parse).and_raise(NoMethodError)
      MyClass.get.should == '0 this'
    end
  end
end

