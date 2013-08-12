class StateUtil
  
  # converts an abbv to a state. 
  def self.abbv_to_state(abbv)
    state_name = Hash.new
    state_name['foo'] = 'bar'
    
    # return the state name.
    state_name[abbv]
  end
  
end