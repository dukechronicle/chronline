web: bundle exec rails server thin -p $PORT -e $RACK_ENV
resque: QUEUE=* env TERM_CHILD=1 bundle exec rake environment resque:work