require 'mysql'

class SqlUtil
  
  def server_version
    begin
      db = Mysql.real_connect("localhost", "root", "password", "test01")
      puts "Server version: " + db.get_server_info
    rescue Mysql::Error => e
      puts "Error code: #{e.errno}"
      puts "Error message: #{e.error}"
      puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
    ensure
      db.close if db
    end
  end

end