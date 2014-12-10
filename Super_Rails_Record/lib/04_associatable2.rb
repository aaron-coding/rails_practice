require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      # Looks up the Association from self class e.g. Cat to
      # the human.
      through_options = self.class.assoc_options[through_name]
      
      # Looks up from the Human class the thing it belongs to
      # e.g. the House
      source_options = 
        through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_pk = through_options.primary_key
      through_fk = through_options.foreign_key
      
      source_table = source_options.table_name
      source_pk = source_options.primary_key
      source_fk = source_options.foreign_key
      key_val = self.send(through_fk)
      
      hashes = DBConnection.execute(<<-SQL, key_val )
      SELECT
        #{source_table}.*
      FROM
        #{through_table}
      JOIN
        #{source_table}
      ON
        #{through_table}.#{source_fk} = #{source_table}.#{source_pk}
      WHERE
        #{through_table}.#{through_pk} = ?
    SQL
    # Query will search where the Human.house_id = house.id
    # and thus will find the house id for the cat.
    
      hashes.map{ |data| source_options.model_class.new(data) }.first
    end
  end
  
end
