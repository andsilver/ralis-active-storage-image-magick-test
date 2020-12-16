# Photo Gallery API

## Project Specifications

**Read-Only Files**
- spec/*

**Environment**  

- Ruby version: 2.7.1
- Rails version: 6.0.2
- Default Port: 8000

**Commands**
- run: 
```bash
bin/bundle exec rails server --binding 0.0.0.0 --port 8000
```
- install: 
```bash
bin/env_setup && source ~/.rvm/scripts/rvm && rvm --default use 2.7.1 && bin/bundle install
```
- test: 
```bash
RAILS_ENV=test bin/rails db:migrate && RAILS_ENV=test bin/bundle exec rspec
```
    
## Question description

In this challenge, you are part of a team that is building a Personal Photo Gallery platform. One requirement is for a REST API service to manage photos using the Rails framework, ActiveStorage, and ImageMagick. You will need to add functionality to add and retrieve photos as well as process photos in the system. The team has come up with a set of requirements including API format, response codes, and image resizing that you must implement.

Each photo has the following structure:

* id: The unique ID of the photo.
* caption: The caption for the photo.
* image: The path to the actual image file.

### Sample photo JSON:

```
{
  "id": 1,
  "caption": "Winter",
  "image": "/rails/active_storage/representations/I6IkJB...dCmH/1.png"
}
```

## Requirements:

`POST /photos`:

* Accepts the following payload:
```
{
  "caption": "Winter",
  "image": <UploadedFile filename="winter.png">
}
```
* The endpoint should validate the following conditions:
  * The caption is set
  * The caption is no longer than 100 characters
  * The image file is present
  * The image format is either JPG or PNG
  * The image size is less than 200 kilobytes
* If any of the above requirements fail, the server should return response code 422.  Otherwise, in case of a successful request, the server should return 201.
* Additionally, the image should be processed in the following way:
  * The filename of image must be changed to the id of the photo in the database. For example, "nature.jpg" should be renamed to "1.jpg" if the photo id in the database is 1.
  * The image should be resized so that it is precisely 300x300px.
* The image should be stored and processed with ActiveStorage and ImageMagick.

`GET /photos`:
* Returns all photos in the system ordered by id in JSON format.
* The HTTP response code should be 200.


## Sample requests and responses

`POST /photos`

Example request:
```
{
  "caption": "Winter",
  "avatar": <UploadedFile filename="winter.png">
}
```

Response:
```
{
  "id": 1,
  "caption": "Winter",
  "avatar": "/rails/active_storage/representations/I6IkJB...dCmH/1.png"
}
```

`GET /photos`

Response:
```
[
  {
    "id": 1,
    "caption": "Winter",
    "avatar": "/rails/active_storage/representations/I6IkJB...dCmH/1.png"
  },
  {
    "id": 2,
    "caption": "Summer",
    "avatar": "/rails/active_storage/representations/eyJfFb...HMi/2.png"
  },
]
```
