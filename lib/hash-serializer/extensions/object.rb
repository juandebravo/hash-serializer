require 'json'

class Object

  #
  # Instance method to parse an object to an equivalent Hash format
  # Used to serialize body data
  #
  def serialize_to_hash(root_name = nil)
    result = Hash.new
    self.instance_variables.each do |column|
      aux = self.instance_variable_get(column)
      unless aux.nil?
        if aux.instance_of?(String) or aux.kind_of?(String)
          # It's required to erase any '_' character because
          # soap4r has included it (not idea about the reason)
          result[self.class.get_column_value(column)] = aux.to_s
        else
          if aux.is_a?(Array)
            result_aux = Array.new
            aux.each do |elem|
              result_aux << elem.serialize_to_hash
            end
          else
            result_aux = aux.serialize_to_hash
          end
          result[self.class.get_column_value(column)] = result_aux
        end
      end
    end
    unless root_name.nil?
      temp = result
      result = {}
      result[root_name] = temp
    end
    result
  end

  #
  # Convert the Hashed object to a String containing the object JSON format
  #
  def serialize_to_json(root_name = nil)
    serialize_to_hash(root_name).to_json
  end

  private

  class << self
    #
    # Retrieves the attribute name
    #
    def get_column_value(column)
      column = column.to_s.sub(/@/, '')
      unless column.index('_').nil?
        column = column.split('_')[1]
      end
      column
    end

  end


end