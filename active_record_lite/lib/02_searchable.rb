require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  
  def where(params)
    where_line = ""
    where_line << params.keys.map { |key| "#{key} = ?" }.join(" AND ")
    results = DBConnection.execute(<<-SQL, *params.values)
        SELECT
          *
        FROM
          #{table_name}
        WHERE 
          #{where_line}
        SQL
        p results
    all_results = []    
    results.each do |result|
      all_results << self.new(result)
    end
    all_results
  end
  
  
end

class SQLObject
    extend Searchable
end
