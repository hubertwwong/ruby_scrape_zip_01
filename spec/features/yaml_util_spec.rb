require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/yaml_util'

describe YamlUtil do
  
  describe 'read' do
    before(:each) do
      @filename = 'config/usps_progress.yml'
    end
    
    it "cur_pos exist" do
      result = YamlUtil.read(@filename)
      result['cur_pos'].should > 0
    end
  end
  
  describe 'write' do
    before(:each) do
      @filename = 'config/usps_progress.yml'
    end
    
    it "cur_pos updates" do
      config = {'cur_pos' => 108}
      result = YamlUtil.write(@filename, result)
      config.should_not be_nil
    end
  end
  
  describe 'read / write' do
    before(:each) do
      @filename = 'config/usps_progress.yml'
    end
    
    it "cur_pos updates" do
      result = YamlUtil.read(@filename)
      result.store('cur_pos', 123)
      result = YamlUtil.write(@filename, result)
      result.should_not be_nil
    end
  end
  
end