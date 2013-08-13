web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
resque: QUEUE=* env TERM_CHILD=1 bundle exec rake environment resque:work
