require_relative 'db_connection'
require 'active_support/inflector'


class SQLObject
  
  
  def self.columns
    result = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      "#{table_name}"
    LIMIT 
      0
    SQL
    result = result.flatten.map { |s_result| s_result.to_sym} 
    result
  end

  def self.finalize!
     columns.each do |col_name|
      define_method(col_name) do
        attributes[col_name]
      end
      define_method("#{col_name}=") do |arg|
        attributes[col_name] = arg
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    result = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      "#{table_name}"
    SQL
    self.parse_all(result)
  end

  def self.parse_all(results)
    objects = []
    results.each do |hash|
      objects << self.new(hash)
    end
    objects       
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
       id = ?
    SQL
    self.new(result.first)
  end

  def initialize(params = {})
    params.each do |k,v|
      if !(self.class.columns.include?(k.to_sym))
        fail "unknown attribute '#{k}'"
      else
        attributes[k.to_sym] = v
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |col| send(col) }
  end

  def insert
    col_names = self.class.columns.each.to_a.join(",")
    question_marks = (["?"] * col_names.split(",").length).join(",")
     DBConnection.execute(<<-SQL, *attribute_values)
        INSERT INTO
          #{self.class.table_name} (#{col_names})
        VALUES
          (#{question_marks})
        SQL
        self.id = DBConnection.last_insert_row_id
  end

  def update
     set_line = self.class.columns.map do |col|
       "#{col} = ?"
     end.join(",")
         
     DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = ?
     SQL
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end
end

