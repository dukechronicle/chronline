#!/bin/bash
rake bower:install

rake db:create

rake sunspot:solr:start

rake db:migrate
rake db:seed

bundle exec unicorn -p $PORT -c ./config/unicorn.rb
