# == Schema Information
#
# Table name: pages
#
#  id              :integer          not null, primary key
#  layout_data     :text
#  layout_template :string(255)
#  path            :string(255)
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Page do
  pending "add some examples to (or delete) #{__FILE__}"
end
