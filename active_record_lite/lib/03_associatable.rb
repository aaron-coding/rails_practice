require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
  end

  def table_name
    # ...
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    
     # define_method("foreign_key") do
    #    "#{name.to_s.singularize}_id".to_sym
    #  end
    #
    #  define_method("primary_key") do
    #    :id
    #  end
    #
    #  define_method("class_name") do
    #    name.to_s.camelcase
    #  end
    
    @foreign_key = options[:foreign_key] || 
       "#{name.to_s.singularize}_id".to_sym
     
    @primary_key = options[:primary_key] || :id
       
       
    @class_name = options[:class_name] || 
       name.to_s.camelcase
       #
     # def foreign_key(name = options[foreign_key])
     #   
     # end
     #
     # def primary_key
     #   
     # end
     #
     # def class_name(name = options[class_name])
     #   
     # end
     #
    #
    # if options[foreign_key].nil?
    #   options[foreign_key] = "#{name.to_s.singularize}_id".to_sym
    # end
    #
    # if options[primary_key].nil?
    #   options[primary_key] = :id
    # end
    #
    # if options[class_name].nil?
    #   options[class_name] = name.to_s.camelcase
    # end
    #
    # options
  end
  
  
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...

end
