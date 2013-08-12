require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/state_util'

describe StateUtil do
  it "foo returns bar" do
    result = StateUtil.abbv_to_state('foo')
    result.should == 'bar'
  end
  
  it "zzzzz returns false" do
    result = StateUtil.abbv_to_state('zzzzz')
    result.should == false
  end
end