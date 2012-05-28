require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Slipcover do
  describe 'CRUD' do
    it "gets" do
      RestClient.should_receive(:get).with("#{Slipcover.host}/foo")
      Slipcover.get('foo')
    end

    it "posts" do
      RestClient.should_receive(:post).with("#{Slipcover.host}/foo", anything)
      Slipcover.post('foo')
    end

    it "posts with data" do
      RestClient.should_receive(:post).with(anything, {:data => 'you know it!'})
      Slipcover.post('foo', {:data => 'you know it!'})
    end

    it "puts" do
      RestClient.should_receive(:put).with("#{Slipcover.host}/foo", anything)
      Slipcover.put('foo')
    end

    it "puts with data" do
      RestClient.should_receive(:put).with(anything, {:data => 'yeah!'})
      Slipcover.put('foo', {:data => 'yeah!'})
    end

    it "deletes" do
      RestClient.should_receive(:delete).with("#{Slipcover.host}/foo")
      Slipcover.delete('foo')
    end
  end
end

