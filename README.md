# Condfig
A simple restful configuration store

# Local Setup
## Requiremens
First, you will need the version of Ruby defined in the .ruby-version file and bundler installed.
You will also need [Redis](http://redis.io). To install it on you machine:

```
brew install redis # on a Mac
apt-get install redis-server # on an Ubuntu Linux box
```

Now you're ready to setup the app:
```
gem install foreman
bundle install
cp .env.sample .env
```

Use this command to run the test suite:

```
bundle exec rspec
```

Run the app with:
```
foreman start
```

The API interface is now available at
[http://127.0.0.1:9292/pages](http://127.0.0.1:9292/page).

# Usage

CREATE a resource:
```
curl -X POST -i -H "Content-Type: application/json" -d '{ "id": "foo", "value": 1 }' http://localhost:9292/pages

HTTP/1.1 201 Created
Content-Type: application/json
location: http://localhost:9292/pages/foo
X-Content-Type-Options: nosniff
Content-Length: 0
```

GET a resource from the API:
```
curl -i -H "Content-Type: application/json" http://localhost:9292/pages/foo

HTTP/1.1 200 OK
Content-Type: application/json
ETag: "ecd1823d79fcb7db0826123bb123149d"
X-Content-Type-Options: nosniff
Content-Length: 22

{"id":"foo","value":1}
```

GET all the available resources:
```
curl -i -H "Content-Type: application/json" http://localhost:9292/pages

HTTP/1.1 200 OK
Content-Type: application/json
ETag: "c17c2722ce3284562710d9883c2016cf"
X-Content-Type-Options: nosniff
Content-Length: 50

{"foo":{"href":"http://localhost:9292/pages/foo"}}
```

UPDATE a resource:
```
curl -X PUT -i -H "Content-Type: application/json" -d '{ "id": "foo", "value": 2}' http://localhost:9292/pages/foo

HTTP/1.1 200 OK
Content-Type: application/json
X-Content-Type-Options: nosniff
Content-Length: 22

{"id":"foo","value":2}
```

DELETE a resource:
```
curl -X DELETE -I http://localhost:9292/pages/foo

HTTP/1.1 204 No Content
X-Content-Type-Options: nosniff
```
