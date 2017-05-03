FactoryGirl.define do 
  factory :url do |f|
    f.full_link Faker::Internet.url
  end
end

