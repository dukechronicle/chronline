RSpec::Matchers.define :include_in_order do |*expected|
  match do |actual|
    (actual & expected) == expected
  end
end

RSpec::Matchers.define :require_authorization do |expected|
  match do |proc|
    proc.call
    response.status.should == Rack::Utils.status_code(:unauthorized)
  end

  failure_message_for_should do |proc|
    "expected #{proc.source_location.join(':')} to require authentication"
  end
end
