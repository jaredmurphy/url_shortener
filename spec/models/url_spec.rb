require "rails_helper"

RSpec.describe URL, :type => :model do
   it "is not valid without a full_link" do 
      link = URL.new(full_link: nil)
      expection(link).to_not be_valid
   end

   it "is not valid without a valid formatted full_link" do 
      link = URL.new(full_link: "httpx://asdf.qwerty")
      expect(link).to_not be_valid
   end

   it "creates a domain based on a valid url" do 
      link = URL.new(full_link: "http://ironmaiden.com/").add_domain
      expect(link.domain).to eq("ironmaiden")
  end
  
  it "hashes the link into a unique short url"

  it "increments access_count with each request"

  it "keeps track of how many times it has been accessed"
  
end
