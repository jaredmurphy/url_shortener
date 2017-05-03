# URL shortenr 

## Plans
#### Rails API
Models: 
* url
  * id
  * hashed_id (base64? base256?) unique 
  * full_url
  * domain

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

