require 'yaml'

thing = YAML.load_file('../config/usps_progress.yml')

puts 'input'
puts thing.inspect
puts thing['cur_pos'].inspect
thing = {'cur_pos' => 130}

File.open("../config/usps_progress.yml", "w") {|f| f.write(thing.to_yaml) }