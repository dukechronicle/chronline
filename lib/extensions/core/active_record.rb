module ActiveRecordExtensions
  extend ActiveSupport::Concern

  module ClassMethods
    # TODO: Create dynamic matchers for plural of attributes
    def find_in_order(ids, property = :id)
      models = self.where(property => ids).map do |model|
        [model.send(property), model]
      end
      models_hash = Hash[models]
      ids.map { |id| models_hash[id] }
    end
  end

  def as_json(options = {})
    json = super(options)
    if options[:properties]
      options[:properties].each do |prop, proc|
        json[prop] = proc.call(self)
      end
    end
    json
  end

end

ActiveRecord::Base.send(:include, ActiveRecordExtensions)
