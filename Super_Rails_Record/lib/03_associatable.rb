require_relative '02_searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || 
       "#{name}_id".to_sym
       
    @primary_key = options[:primary_key] || :id
    @class_name = options[:class_name] || 
       name.to_s.camelcase

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    
    @foreign_key = options[:foreign_key] || 
       "#{self_class_name.to_s.downcase}_id".to_sym
     
    @primary_key = options[:primary_key] || :id
       
    @class_name = options[:class_name] || 
       name.to_s.singularize.camelcase
  end
end

module Associatable
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name, options)
    #save assoc_options for use in the has_one_through
    
    define_method(name) do  
      options = BelongsToOptions.new(name, options)
      val_of_our_foreign_key = self.send(options.foreign_key)
      hashes = DBConnection.execute(<<-SQL, val_of_our_foreign_key)
      SELECT *
      FROM #{options.table_name}
      WHERE #{options.primary_key} = ?
      LIMIT 1
      SQL
      
      hashes.map{ |data| options.model_class.new(data) }.first
    end

  end

  def has_many(name, options = {})
    define_method(name) do                           
      options = HasManyOptions.new(name, self.class.name, options)
      val_of_our_self_id = self.send(options.primary_key)
       hashes = DBConnection.execute(<<-SQL, val_of_our_self_id)
       SELECT *
       FROM #{options.table_name}
       WHERE #{options.foreign_key} = ?
       SQL
      
      hashes.map { |data| options.model_class.new(data) }
    end
    
  end

  def assoc_options
    @assoc_options ||= {}
       @assoc_options
  end
  
  
end

class SQLObject
  extend Associatable

end
