# Capistrano VPS

TODO: Write a gem description

 + Override capify!
 * name of application (?)
 * IP

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano_vps', :git => "git://github.com/sbusso/capistrano_vps.git", :require => false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano_vps

## Usage

Capistrano Recipes

```
ssh root@72.14.183.209
addgroup admin
adduser deployer --ingroup admin
exit

cat ~/.ssh/id_rsa.pub | ssh deployer@72.14.183.209 'cat >> ~/.ssh/authorized_keys'
ssh-add # -K on Mac OS X

cap deploy:install
cap deploy:setup
cap deploy:cold
cap deploy:migrations
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
