# URL Shortener 

##### About this README
This markdown file contains information about the project as a whole, including wins, challenges, and an explanation of the shortening algorithm. It also contains information about the Rails API specifically - such as setup and install. Information for the client side app written in Ember can be found - [here](https://github.com/jaredmurphy/url_shortener_client)

##### Deployment 
You can find the deployed Rails API deployed on Heroku [here](https://url-shortenerapi.herokuapp.com/api/v1/tops)

The deployed Ember app is also on Heroku [here](https://protected-reaches-70331.herokuapp.com/)

##### Setup and Install
To set up the Rails API:
* Clone this repo 
* run `bundle install`
* run `rails db:setup`

To run tests:
* run `rspec`

To start the server
* run `rails server`

***NOTE*** This app uses a postgresql database, so you will need to make sure you have it installed. 

### Project 

##### Shortening Algorithm
The alrgorithm I wound up with takes in the id of the recently created item and generates a string that represents the id number in Base64. This allowed me to only have the bare minimum number of characters in the `short_link`, in a similar way to how Bitly and TinyUrl accomplish this. I chose Base64, which in this case was Base62 plus "_" and "-". This will allow me to have smaller minimum characters than Base62, and is still url safe. The algorithm uses a bijective function, which allows the `short_link` in Base64 to be directly transposed to the original `full_link`. There are two functions that make this happen in the model bijective\_encode and bijective\_decode. The former takes Base10 into Base64 and the later takes Base64 into Base10. When the app saves a url to the database it encodes the id, and then when someone follows the short link back to our app it decodes the short\_link and finds the serial id, then redirects to the original full length url. 

##### Wins 
I had a lot of fun building this app out. There's a few things I feel really happy about. 
1. Client-side app built in Ember.

I used Bootstrap to do some the styling on this app.I really wanted to develop the client in Ember to demonstrate my ability to pick up new things, given my very limited experience with it. I'm finding Ember to be nice to work with. 

2. BDD 

The Rails API (other than the shortening algorithm) was pretty much all developed by writing RSpec tests first before writing the code. I included model and request specs. I used FactoryGirl and Faker to test creation and behavior of the Url model. 

3. Met core requirements, had fun 

##### Challenges
1. Shortening Algorithm 

I definitely feel like this was the biggest challenge for this project. I was able to find an elegant solution to make urls as short as possible, but it took me some time to get there. I had written a previous solution that produced similar results by generating a Base64 string of the smallest length by iterating through permutations of the Base64 alphabet. However, this method relied on the `short_link` of the previous record, and may have reliablity issues with many requests. Creating the `short_link` based on the id of the `Url` was a better approach. 

2. There were many reach goals I wanted to get to, but did not have time for.
