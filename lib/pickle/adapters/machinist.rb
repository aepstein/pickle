module Pickle
  class Adapter
    class Machinist < Adapter
      def self.adapters
        adapters = []
        OrmAdapter.model_classes.each do |model_class|
          if blueprints = model_class.instance_variable_get('@blueprints')
            blueprints.keys.each {|blueprint| adapters << new(model_class, blueprint)}
          end
        end
        adapters
      end

      def initialize(model_class, blueprint)
        @model_class, @blueprint = model_class, blueprint
        @name = @model_class.name.underscore.gsub('/','_')
        @name = "#{@blueprint}_#{@name}" unless @blueprint == :master
      end

      def make(attrs = {})
        begin
          @model_class.send(:make!, @blueprint, attrs) # Machinist 2
        rescue
          @model_class.send(:make, @blueprint, attrs)
        end
      end
    end
  end
end