class Staff < ActiveRecord::Base
  attr_accessible :affiliation, :biography, :columnist, :name, :tagline, :twitter
end

class Author < Staff

end
