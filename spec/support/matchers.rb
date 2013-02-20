RSpec::Matchers.define :include_in_order do |*expected|
  match do |actual|
    (actual & expected) == expected
  end
end
