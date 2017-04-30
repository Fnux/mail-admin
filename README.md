# Mail-admin

Simple mail server web interface, written in ruby using
[sinatra](http://www.sinatrarb.com/).

It's just a stupid webapp writing into the followings fields of a database :

| domains    | users      |  aliases    |
|:----------:|:----------:|:-----------:|
| id         | id         | id          |
| name       | mail       | source      |
|            | password   | destination |

You can configure a few things in the `config.yml` file.

## Setup

```
# Clone the project, copy (and fill) the example config file
bundle install
rackup # for development, take a look to thin or unicorn for production
```

```
-- Database initialization
CREATE TABLE domains(
  id INT PRIMARY KEY NOT NULL,
  name CHAR(50) NOT NULL
);

CREATE TABLE users(
  id INT PRIMARY KEY NOT NULL,
  mail CHAR(50) NOT NULL,
  password CHAR(50) NOT NULL
);

CREATE TABLE aliases(
  id INT PRIMARY KEY NOT NULL,
  source CHAR(50) NOT NULL,
  destination CHAR(50) NOT NULL
);
```

