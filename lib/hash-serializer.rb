# Include json only if it's not loaded before
Object.respond_to? :to_json or require 'json'

module HashSerializer
  
  class << self
    #
    # Instance method to parse an object to an equivalent Hash format
    # Used to serialize body data
    #
    def to_hash(obj, root_name = nil)
      result = Hash.new
      obj.instance_variables.each do |column|
        aux = obj.instance_variable_get(column)
        unless aux.nil?
          if aux.instance_of?(String) or aux.kind_of?(String)
            # It's required to erase any '_' character because
            # soap4r has included it (not idea about the reason)
            result[get_column_value(column)] = aux.to_s
          else
            if aux.is_a?(Array)
              result_aux = Array.new
              aux.each do |elem|
                result_aux << HashSerializer.to_hash(elem)
              end
            else
              result_aux = HashSerializer.to_hash(aux)
            end
            result[get_column_value(column)] = result_aux
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
    def to_json(obj, root_name = nil)
      to_hash(obj, root_name).to_json
    end

    private

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
