# config/initializers/mini_sql.rb

require 'mini_sql'

# Initialize MiniSql connection globally
pg_conn = PG.connect(dbname: 'api_development')
MINI_SQL = MiniSql::Connection.get(pg_conn)
