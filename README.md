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
| created_at | created_at | created_at  |

## configuration

The `config.yml` file allow you to configure some parameters.

* **sinatra-reloader :** auto-reload the app if you modify the code. Useful for development. Requires the `sinatra-contrib` gem. [Documentation](http://www.sinatrarb.com/contrib/reloader.html).
* **id & password :** the ID and the password of the user.
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
apt-get install ruby ruby-sinatra ruby-sequel # + adapter : ruby-sqlite3, ruby-mysql2, ruby-pg
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

## Mail server configuration

Here is the configuration I use on my mail servers.

### Postfix (MTA)

You'll need the `postfix-pgsql` or `postfix-mysql` package (Debian/Ubuntu).

At the bottom of `/etc/postfix/mail.cf` **(don't forget to replace `ADAPTER` by `mysql` or `pgsql`)** :

```
# A list of all virtual domains serviced by this instance of postfix.
virtual_mailbox_domains = ADAPTER:/etc/postfix/ADAPTER/virtual-domain-maps.cf

# Look up the mailbox location based on the email address received.
virtual_mailbox_maps = ADAPTER:/etc/postfix/ADAPTER/virtual-user-maps.cf

# Any aliases that are supported by this system
virtual_alias_maps = ADAPTER:/etc/postfix/ADAPTER/virtual-alias-maps.cf,hash:/etc/aliases
```

Then add and fill the following config files.

In `/etc/postfix/ADAPTER/virtual-domain-maps.cf`.

```
user = db_user
password = db_pwd
dbname = db_name
hosts = 127.0.0.1
query = SELECT 1 FROM domains WHERE name = '%s';
```

In `/etc/postfix/ADAPTER/virtual-user-maps.cf`.

```
user = db_user
password = db_pwd
dbname = db_name
hosts = 127.0.0.1
query = SELECT 1 FROM users WHERE mail='%s';
```

In `/etc/postfix/ADAPTER/virtual-alias-maps.cf`.

```
user = db_user
password = db_pwd
dbname = db_name
hosts = 127.0.0.1
query = SELECT destination FROM aliases WHERE source='%s';
```


### Dovecot

You'll need the `dovecot-pgsql` or `dovecot-mysql` package (Debian/Ubuntu).

Please configure dovecot to use a SQL database (as explained in
[this great tutorial on DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-configure-a-mail-server-using-postfix-dovecot-mysql-and-spamassassin) for example) and use the following query in
    `dovecot-sql.conf.ext `.

```
password_query =  SELECT mail as user, password FROM users WHERE mail='%u';
```
