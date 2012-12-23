include ActionDispatch::TestProcess


FactoryGirl.define do
  factory :image do
    caption "Ash battles Gary to become the Pokemon champion."
    location "Pokemon Stadium"
    original { fixture_file_upload('lib/sample-images/pikachu.png') }
  end
end
