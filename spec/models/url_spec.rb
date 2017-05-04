require "rails_helper"

RSpec.describe Url, :type => :model do
  it "is not valid without a full_link" do
    link = Url.create(full_link: nil)
    expect(link).to_not be_valid
  end

  it "is not valid without a valid formatted full_link" do
    link = Url.create(full_link: "httpx://asdf.qwerty")
    expect(link).to_not be_valid
  end

  it "is valid with a valid formatted full_link" do
    link = FactoryGirl.create(:url)
    link.generate_short_link
    expect(link).to be_valid
  end

  it "has a default access count of 0" do
    link = FactoryGirl.create(:url)
    link.generate_short_link
    expect(link.access_count).to eq(0)
  end

  it "increments access count each time it is viewed" do
    link = FactoryGirl.create(:url)
    link.generate_short_link
    3.times { link.increment_access_count }
    expect(link.access_count).to eq(3)
  end

  #it "hashes the link into 7 character string" do
  #  link = FactoryGirl.create(:url)
  #  expect(link.short_link).to be_a(String)
  #  expect(link.short_link.length).to eq(7)
  #end
end
