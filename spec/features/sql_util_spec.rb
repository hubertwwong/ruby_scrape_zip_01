require File.dirname(__FILE__) + '/../spec_helper'
require_relative '../../src/sql_util'

require 'rubygems'

describe SqlUtil do
  
  describe "test_01 db" do
    before(:each) do
      user = 'root'
      password = 'password'
      url = 'localhost'
      db_name = 'test01'
      @db = SqlUtil.new(:url => url, :user=> user, :password => password, :db_name => db_name)
    end
    
    describe "server_version" do
      it "returns a string" do
        result = @db.server_version
        result.should include 'Server version'
      end
    end
    
    describe "num_rows" do
      it "car db returns 3" do
        result = @db.num_rows('car')
        result.should == 3
      end
    end
    
    describe "read_last_row" do
      it "car db order by make will return toyota" do
        result = @db.read_last_row('car', 'make')
        result['make'].should == 'toyota'
      end
    end
    
    describe "read_one_param" do
      it "car db order by make will return toyota" do
        result = @db.read_with_one_param('car', 'make', 'foo')
        result['model'].should == 'bar'
      end
    end
    
    describe "col_names" do
      it "car db returns id, name, model array" do
        result = @db.read_col_names('car')
        result.should == ['id', 'make', 'model']
      end
    end
    
    describe "hash_array" do
      it "return a hash off 2 arrays" do
        arr1 = ['a', 'b', 'c']
        arr2 = ['d', 'e', 'f']
        result = @db.hash_arrays(arr1, arr2)
        result.should == {'a' => 'd', 'b' => 'e', 'c' => 'f'}
      end
    end
    
    describe "hash_get_keys_as_str" do
      it "returns a comma seperated string" do
        arr1 = {'a' => 'd', 'b' => 'e', 'c' => 'f'}
        result = @db.hash_get_keys_as_str(arr1)
        result.should == 'a, b, c'
      end
    end
    
    describe "hash_get_values_as_str" do
      it "returns a space seperated string" do
        arr1 = {'a' => 'd', 'b' => 'e', 'c' => 'f'}
        result = @db.hash_get_keys_as_str(arr1)
        result.should == 'a, b, c'
      end
    end
    
  end
  
end