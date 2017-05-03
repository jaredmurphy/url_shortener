require "rails_helper"

RSpec.describe Url, :type => :model do
   it "is not valid without a full_link" do 
      link = Url.new(full_link: nil)
      expect(link).to_not be_valid
   end

   it "is not valid without a valid formatted full_link" do 
      link = Url.new(full_link: "httpx://asdf.qwerty")
      expect(link).to_not be_valid
   end

   it "is valid with a valid formatted full_link" do 
      link = Url.new(full_link: "http://ironmaiden.com/")
      expect(link).to be_valid
  end

  it "has a default access count of 0" do 
      link = Url.new(full_link: "http://ironmaiden.com/")
      expect(link.access_count).to eq(0)
  end

  it "increments access count each time it is viewed" do 
      link = Url.new(full_link: "http://ironmaiden.com/")
      3.times { link.increment_access_count }
      expect(link.access_count).to eq(3)
  end
  
  it "hashes the link into a unique short url"

  it "increments access_count with each request"

  it "keeps track of how many times it has been accessed"
  
end
