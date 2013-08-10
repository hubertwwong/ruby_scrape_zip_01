require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/sql_util'

require 'rubygems'

describe SqlUtil do
  
  describe "server_version" do
    it "will return a string" do
      s = SqlUtil.new
      s.server_version
    end 
  end
  
end
