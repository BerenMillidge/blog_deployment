JEKYLL := 3.8.6  
DEPLOY_DIR := ../docker-data/nginx/site.PHONY: clean

clean:  
	rm -rf _site  
	rm -rf .jekyll-cache.PHONY: build

build:  
	docker run --rm \  
        -v "${PWD}:/srv/jekyll" \  
        -v "${PWD}/vendor/bundle:/usr/local/bundle" \  
        jekyll/jekyll:${JEKYLL} \  
        jekyll build.PHONY: serve

serve: clean _serve.PHONY: _serve

_serve:  
     docker run --rm \  
         -p "4000:4000" \  
         -v "${PWD}:/srv/jekyll" \  
         -v "${PWD}/vendor/bundle:/usr/local/bundle" \  
         jekyll/jekyll:${JEKYLL} \  
         jekyll serve.PHONY: copy

copy:  
    rsync -avP ./\_site/* ${DEPLOY\_DIR}.PHONY: deploy

deploy: clean build copy