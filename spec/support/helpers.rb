module Helpers
  def json_attributes(obj, options = {})
    ActiveSupport::JSON.decode(obj.to_json(options))
  end
end
