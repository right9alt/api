# config/initializers/mini_sql.rb

require 'mini_sql'

# Check if the environment is development and the database exists
begin
  # Attempt to connect to the database
  pg_conn = PG.connect(host: 'postgres', user: 'postgres', password: 'postgres', dbname: 'api_development')
  MINI_SQL = MiniSql::Connection.get(pg_conn)
rescue PG::ConnectionBad
  # Handle the case where the database doesn't exist yet
  puts "Database does not exist yet. Skipping MiniSql initialization."
end

