RSpec::Matchers.define :include_in_order do |*expected|
  match do |actual|
    (actual & expected) == expected
  end
end

RSpec::Matchers.define :require_authorization do |expected|
  match do |proc|
    proc.call
    response.should == have_status_code(:unauthorized)
  end

  failure_message_for_should do |proc|
    "expected #{proc.source_location.join(':')} to require authentication"
  end
end

RSpec::Matchers.define :have_status_code do |expected|
  match do |response|
    response.status == Rack::Utils.status_code(expected)
  end
end
