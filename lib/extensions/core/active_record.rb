module ActiveRecordExtensions
  extend ActiveSupport::Concern

  module ClassMethods
    def find_in_order(ids)
      models = self.where(id: ids).map {|model| [model.id, model]}.to_h
      ids.map {|id| models[id]}
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
