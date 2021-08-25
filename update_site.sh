#!/bin/bash

# this pulls the gh repo and updates static files from jekyll and serves them
# call this whenever the upstream github repo changes
# this requires you to enter your gh credentials
cd BerenMillidge.github.io
git pull -r
# make file
make -C ~/blog_deployment/BerenMillidge.github.io/../ deploy
docker exec nginx-site nginx -s reload
