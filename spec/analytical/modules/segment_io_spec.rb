require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Analytical::Modules::SegmentIo" do
  before(:each) do
    @parent = mock('api', :options=>{:google=>{:js_url_key=>'abc'}})
  end
  describe 'on initialize' do
    it 'should set the command_location' do
      a = Analytical::Modules::SegmentIo.new :parent=>@parent, :js_url_key=>'abc'
      a.tracking_command_location.should == :body_prepend
    end
    it 'should set the options' do
      a = Analytical::Modules::SegmentIo.new :parent=>@parent, :js_url_key=>'abc'
      a.options.should == {:js_url_key=>'abc', :parent=>@parent}
    end
  end
  describe '#identify' do
    it 'should return a js string' do
      @api = Analytical::Modules::SegmentIo.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.identify('id', {:email => 'test@test.com'}, {:attribute_1 => "Some Value", :attribute_2 => "Some Other Value"}).should ==
      "seg.identify(\"test@test.com\", {\"attribute_1\":\"Some Value\",\"attribute_2\":\"Some Other Value\"});"
    end
  end
  describe '#track' do
    it 'should return a js string' do
      @api = Analytical::Modules::SegmentIo.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.event('Big Deal', {:something => 'good'}).should == "seg.track(\"Big Deal\", #{{:something=>'good'}.to_json});"
    end
  end

  describe '#init_javascript' do
    it 'should return the init javascript' do
      @api = Analytical::Modules::SegmentIo.new :parent=>@parent, :js_url_key=>'abcdef'
      @api.init_javascript(:head_prepend).should == ''
      @api.init_javascript(:head_append).should == ''
      @api.init_javascript(:body_prepend).should =~ /d47xnnr8b1rki\.cloudfront\.net/
      @api.init_javascript(:body_prepend).should =~ /abcdef/
      @api.init_javascript(:body_append).should == ''
    end
  end
end