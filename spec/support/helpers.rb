module Helpers
  def json_attributes(obj)
    ActiveSupport::JSON.decode(obj.to_json)
  end
end
