# Mail-admin

This is a simple mail server web interface, written in ruby using
[sinatra](http://www.sinatrarb.com/). I actually use it with a `postfix` +
 `dovecot` setup.

It's just a stupid webapp writing into the followings fields of a database :

| Domains    | Users      |  Aliases    |
|:----------:|:----------:|:-----------:|
| id         | id         | id          |
| name       | mail       | source      |
|            | password   | destination |

## configuration

The `config.yml` file allow you to configure some parameters.

* **sinatra-reloader :** auto-reload the app if you modify the code. Useful for development. Requires the `sinatra-contrib` gem. [Documentation](http://www.sinatrarb.com/contrib/reloader.html).
* **admins :** admin users, separeted by `;`.
* **secret :** used to encrypt the session cookie. **YOU MUST CHANGE IT**
* **database parameters :** parameters required for you database. The adapter can me `sqlite3`, `pgsql` or `mysql`.

## Webapp Setup

Obviously, you first need ruby.

```
sudo apt-get install ruby # Debian, Ubuntu, etc.
sudo dnf install ruby # Fedora
sudo pacman -S ruby # Arch
```

### Dependencies
#### Using apt-get (Debian)

You just have to install the following :

```
apt-get install ruby ruby-sinatra ruby-sinatra-contrib ruby-sequel # + adapter : ruby-sqlite3, ruby-mysql2, ruby-pg
```

#### Using Rubygems (any distribution)

You just have to install the following :

```
gem install sinatra sinatra-contrib rack sequel # + adapter : sqlite3, mysql2, pg
```

### Initialize the database

Please configure the `database` parameters in the `config.yml` file and run the
following script from the root directory of the app. The script creates the tables
and fields of the database.

```
ruby scripts/initialize_database.rb
```

### Deployment

On your computer, you just have to run the `rackup` command at the root
directory of this repo. For production, you'll have to setup a thin or
unicorn worker. Please take a look to
[the documentation](http://recipes.sinatrarb.com/p/deployment) on the subject.

*PS : `thin` or `unicorn` are both great. Passenger is way too heavy. It is also
possible to deploy via `FastCGI`. Note that `unicorn` is packaged for Debian.*
