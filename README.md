Chronline
=========

Setting Up
----------

First you need [git](http://git-scm.com/book/en/Getting-Started-Installing-Git) in order to clone this repository. Next, you will need Ruby 1.9.3. You should install ruby and rubygems with [rvm](https://rvm.io/rvm/install/). You should also get Node.js and npm. I recommend using [nvm](https://github.com/creationix/nvm) to install them. Once you have those utilities, clone this repository and change into the directory. Then execute the following in your shell:

```bash
# Globally install Node.js utility binaries
$ npm install -g bower phantomjs

# Install required gems
$ bundle install --without production

# Install client side vendor assets with bower
$ rake bower:install
$ rake bower:resolve

# Rails database initialization
$ rake db:migrate
$ rake db:test:prepare

# Start local solr server
$ rake sunspot:solr:start
```

### Configuration files

You will be able to run tests at this point, but will not be able to run the server in the development environment until you supply the `config/settings/development.local.yml` file. This is not version controlled since it contains sensitive information. You can populate it using the `config/settings/test.yml` file as a template.

Once the development environment is configured it, you may wish to populate your development database with random data using the command `$ rake db:populate`.

Testing
=============

Writing Tests
-------------

### RSpec

Resources:

 - [Built in RSpec matchers](https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers)
 - [Better Specs RSpec Guildines](http://betterspecs.org/)
 - [Shoulda Matchers](http://rubydoc.info/github/thoughtbot/shoulda-matchers/master/frames)

### Cucumber

Resources:

 - [Official Cucumber Site](http://cukes.info/)
 - [Gerkin Reference](https://github.com/cucumber/cucumber/wiki/Gherkin)

Running Tests
-------------

You can run acceptance tests with the following command:

```bash
$ cucumber features
```

You can run spec tests with the following command:

```bash
$ rspec spec
```

You can run tests continuously during development in a dedicated console.

TODO Continuous testing hasn't been fully vetted; proceed with caution

```bash
$ guard
```

Style Considerations
====================

To stay consistent with the style of this project, please abide by the following guidelines:

- Use Ruby 1.9 syntax for hashes and lambdas:
  ```
  # bad
  {:a => 1, 'b' => 2}
  lambda {|x, y| x + y}

  # good
  {a: 1, 'b' => 2}
  ->(x, y) {x + y}
  ```
- Use Rails ActiveSupport helpers whenever possible:
  ```
  # bad
  x.nil? || x.length == 0
  !(x.nil? || x.length == 0)
  JSON.parse(x)

  # good
  x.blank?
  x.present?
  ActiveSupport::JSON.decode(x)
  ```
- Use Pokemon references liberally when writing tests. Only the first 151 Pokemon are recognized.


Test Customizations
-------------------

Several options may be configured for your development pleasure via `/config/settings/test.local.yaml`

TODO Customizations are rather volatile, so be careful!

```yaml
growl: true  # OS X Only, requires [Growl](http://growl.info/) to be installed
rspec:
  formatter: NyanCatFormatter # Options are NyanCatFormatter, NyanCatMusicFormatter, Fuubar, documentation, progress; defaults to progress
spork: # See "Available Options"  at https://github.com/guard/guard-spork
  rspec: true
  cucumber: false # Default is true

```

Sitemap
===============
To generate the sitemap, run rake
sitemap:refresh CONFIG_FILE="config/news_sitemap.rb"

Other Resources
===============

 - [HAML](http://haml.info/)
 - [SimpleForm](http://simple-form.plataformatec.com.br/)
 - [Capybara](http://jnicklas.github.com/capybara/)
 - [Pry](http://pryrepl.org/)
