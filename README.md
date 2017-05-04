# URL shortenr 

#### Short Url encoding
EDIT: 
* I need the url to be the SHORTEST POSSIBLE length, rather than choosing 7 characters like I previously planned. 
* I can continue using Ruby's SecureRandom.urlsafe_base64, which will allow me to get a random string given the number of bytes I need it to use. 

Example:
```
SecureRandom.urlsafe_base64(1)
#=> "tA"

SecureRandom.urlsafe_base64(2)
#=> "dIU"

SecureRandom.urlsafe_base64(3)
#=> "7AXP"
```

So, if I know I already have 4096 (64 x 64) entries in the database, then the algorithm can ask for the byte length of 2 which will increase the hash length to 3 characters.  

**I anticipate a problem with this approach** which is that the randomly assigning a hash will become more and more expensive as the application grows and more and more items are persisted in the db. 

**The solution to this problem**, I think is most likely generating 64base strings off the primary key of the db entries, rather than assigning a random 64base string. I wanted to avoid this approach initially, because of security concerns with exposing incremental values. However, 1) the data in this app is NOT sensitive. 2) the project does not call for any security measures. 

Next step is encoding primary keys into 64base (and url safe) strings. 

================

Previous thoughts: 
* going with base64 - used by Google for their Youtube id's
* ~~Bitly uses 7 characters~~
* looked at base 62 (to avoid base64 issues with url) but found Ruby's urlsafe_base64. 
* so i get benefits of base64 without the problems associated with url characters 
* ~~The plan is to generate a random base64 string with secure random to avoid incremental id's and to ensure that we can get the largest number of unique ids in 7 characters'~~

Exmple: 
```
 SecureRandom.urlsafe_base64(5)

#=> "ZWPKTOQ"
```

#### todo 
* update shortening algorithm to make urls as short as possible
* handle case for url already exists
* cors

## Thoughts
#### Rails API
Models: 
* url
  * id
  * hashed_id (base64? base256?) unique 
  * full_url
  * domain
  * # of times accessed

Routes:
* Get 
  * /urls/:hashed_id
    * => will redirect to full url
  * /urls/lists/top
    * top 100 links (by number of times accessed)
* Post 
  * /urls
    * create new url 
    * or send back a previous one if that link exists

* URL shortner - should happen either in model or let SQL handle it


#### Testing 
1. Url 
  * valid url?
    * format - solve with RegEx



##### Reach Goals
* bot to keep hitting links 
* web sockets
* private urls - keep track of yours only
* without signing in you just use public ones
* custom url? - only with user auth 
* some kind of timer to prevent bots from rapid fire clicks
* lists of links - private or public 


