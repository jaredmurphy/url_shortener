FactoryGirl.define do
  factory :url do
    sequence(:full_link) { |n| "#{Faker::Internet.url}/#{n}" }
  end

  factory :url_already_accessed, parent: :url do
    sequence(:access_count) {|n| n }
  end

end

