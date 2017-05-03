# URL shortenr 

#### Short Url encoding
* going with base64 - used by Google for their Youtube id's
* Bitly uses 7 characters. 
* looked at base 62 (to avoid base64 issues with url) but found Ruby's urlsafe_base64. 
* so i get benefits of base64 without the problems associated with url characters 
* The plan is to generate a random base64 string with secure random to avoid incremental id's and to ensure that we can get the largest number of unique ids in 7 characters

Exmple: 
```
 SecureRandom.urlsafe_base64(5)

#=> "ZWPKTOQ"
```

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


