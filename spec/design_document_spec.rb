describe Slipcover::DesignDocument do
  before do
    @views = {
      :all => {
        :map => "function(doc) {
          emit(null, doc);
        }"
      }
    }

    @database = Hashie::Mash.new(:url => "http://foo.bar:3456")
    @design = Slipcover::DesignDocument.new('my_design', @database, @views)
  end

  describe 'initialize' do
    it "has a database" do
      @design.database.should == @database
    end

    it 'creates the id from the name' do
      @design.id.should == "_design/my_design"
    end

    it 'has a rev of nil' do
      @design.rev.should == nil
    end

    it 'sets the views to the passed in argument' do
      @design.views[:all][:map].should == @views[:all][:map]
    end

    it 'will set an empty views Mash if no views argument is passed in' do
      design = Slipcover::DesignDocument.new('my_design', @database)
      design.views.should == Hashie::Mash.new
    end
  end

  describe 'data' do
    it "only includes the views" do
      @design.data.keys.should == ['views']
      @design.data[:views][:all][:map].should == @views[:all][:map]
    end
  end

  describe 'view accessors' do
    it "sets" do
      @design[:foo] = {:map => 'function() {}'}
      @design.views[:foo][:map].should == "function() {}"
    end

    it "gets" do
      @design.views[:baz] = {:zardoz => "function(another) {return another;}"}
      @design[:baz][:zardoz].should == "function(another) {return another;}"
    end
  end
end
