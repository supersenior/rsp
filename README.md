== RSRP

Recognize.

## Get it running locally
You will need to have the heroku toolbelt to use the heroku CLI

```
$ bundle
$ npm install
$ heroku pg:backups capture --app watchtowerapp
$ curl -o latest.dump `heroku pg:backups public-url --app watchtowerapp`
$ bundle exec rake db:drop db:create && pg_restore --verbose --clean --no-acl --no-owner -h localhost -d rsrp_development latest.dump && bundle exec rake db:test:prepare
```

## Copying Production to Edge
$ heroku pg:copy watchtower-prod::DATABASE DATABASE_URL --app watchtowerapp

Then start up the server and navigate to localhost:3000/projects/1

## Deployment Instructions

```
1. Push to heroku:master
2. heroku run rake db:migrate # if needed
```
