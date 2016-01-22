# Mail-admin

This is a simple mail server web interface, written in ruby using [sinatra](http://www.sinatrarb.com/). I actually use it with a postfix+dovecot setup.

### Setup

Obviously, you first need ruby.

```
sudo apt-get install ruby # Debian, Ubuntu, etc.
sudo dnf install ruby # Fedora
sudo pacman -S ruby # Arch
```

Then, you have to install few dependencies using rubygems.

```
gem install rack
gem install sinatra
gem install sinatra-reloader # only if you want to use sinatra-reloader
gem install data_mapper
gem install dm-sqlite-adapter # or any data_mapper adapter
```

And you can start the server :

```
rackup # in the application root directory
```

### Production

You can deploy a ruby (rack) application using unicorn, passenger, fastcgi, thin or whatever.
Please refer to [the Sinatra Documentation on the subject](http://recipes.sinatrarb.com/p/deployment).

I for one recommend [this method](http://recipes.sinatrarb.com/p/deployment/lighttpd_proxied_to_thin), using thin and nginx.
