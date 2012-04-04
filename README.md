# Capistrano VPS

TODO: Write a gem description

 + Override capify!
 * name of application (?)
 * IP

## Installation

Add this line to your application's Gemfile:

    gem 'activelabs-recipes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activelabs-recipes

## Usage

Capistrano Recipes

```
ssh root@72.14.183.209
addgroup admin
adduser deployer --ingroup admin
exit
cap deploy:install
cap deploy:setup
cap deploy:cold
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
