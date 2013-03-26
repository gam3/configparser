# encoding: utf-8
require 'minitest/autorun'
require 'configparser'

class TestConfigparser < MiniTest::Spec
  it "should parse a simple config" do
    cp = ConfigParser.new('test/simple.cfg')
    assert !cp.nil?()
    assert_equal('hi',cp['test1'])
    assert_equal('hello',cp['test2'])
    assert_equal('55',cp['first_section']['mytest'])
    assert_equal('99',cp['first_section']['yourtest'])
    assert_nil(cp['first_section']['nothere'])
    assert_equal('or the highway',cp['second section']['myway'])
  end
  
  it "should convert a simple config to a string" do
    cp = ConfigParser.new('test/simple.cfg')
    doc = "test1: hi
test2: hello
[first_section]
myboolean
mytest: 55
yourtest: 99
[second section]
myway: or the highway
"
    assert_equal(doc,cp.to_s)
  end
  
  it "should parse a config with substitutions" do
    cp = ConfigParser.new('test/complex.cfg')
    assert !cp.nil?()
    assert_equal('strange-default-whatever',cp['global2'])
    assert_equal('strange-default-whatever-yodel-local',cp['section1']['local1'])
    assert_equal('recent hotel',cp['section2']['local2'])
    assert_equal('un$(resolvable)',cp['section2']['local3'])
  end

  it "should fail to parse a config with bad syntax" do
    cp = ConfigParser.new('test/bad.cfg')
    assert_equal(<<EOP,cp.to_s)
myboolean
mytest: 55
myway: or the highway
test1: hi
test2: hello
yourtest: 99
[last section]
bill: jack
bob: bob
EOP
  end

  it "should fail to parse a non-exsistant file" do
    lambda { cp = ConfigParser.new('test/bab.cfg') }.must_raise(Errno::ENOENT)
  end
end
