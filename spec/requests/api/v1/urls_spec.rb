RSpec.describe "Urls API" do
  it "redirects to full link" do 
    link = FactoryGirl.create(:url)
    get "/#{link.short_link}"
    expect(response.status).to eq(302) 
    expect(response).to redirect_to("#{link.full_link}")
  end

  it "sends a list of top 100 links" do 
    FactoryGirl.create_list(:url_already_accessed, 100)
    get "/api/v1/urls/lists/top"
    json = JSON.parse(response.body)
    expect(response).to be_success
    expect(json.length).to eq(100)
    expect(json.first["access_count"] > json.last["access_count"])
  end
  
  context "when the url is valid" do 
    context "when the Url does not yet exist in the database" do 
      it "creates a new Url in the database" do 
        link = FactoryGirl.build(:url)
        post "/api/v1/urls", params: { url: {full_link: link.full_link} }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(json["full_link"]).to eq(link.full_link)
      end
    end

    context "when the url is invalid" do 
      it "returns an error message" do 
        link = "httpx:asdf.qwerty" 
        post "/api/v1/urls", params: { url: {full_link: link} }
        expect(response.status).to eq(400) 
      end
    end
  end
end
