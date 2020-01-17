#!/bin/sh
docker run -it -p4000:4000 -v`pwd`:/src --mount type=volume,src=bloggems,dst=/usr/local/bundle -w /src jekyll/builder:3.8.5 jekyll serve --drafts --force_polling --incremental
