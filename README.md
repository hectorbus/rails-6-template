
# Rails 6 Admin Template

Rails 6 Web ​Application template.

## Requirements

+ Ruby: 2.5.5
+ Ruby on Rails: 6.0.2.1
+ PostgreSQL: 9.5 or higher.

## Installation
### System dependencies

Before running the application it is necessary to have a properly installed Ruby environment. It is recommended to install a Ruby version manager, such as [RVM](https://rvm.io/) or [RBENV](http://rbenv.org/).

Once the Ruby environment is configured, install the necessary gems by executing the following steps in the terminal:

+ In the project's root directory: `$ cd <project root directory>`
+ Install the gems using: `$ bundle install`

### Initial setup​
#### Database Creation

​The project is designed to use Ruby on Rails default configurations, so it is not necessary to modify the database.yml file. It is only necessary to have a PostgreSQL installation and a superuser with the same name as the session user. In the root directory of the project execute the following commands:

```bash

$ rails db:create

$ rails db:migrate

```

## Deployment

#### Local deployment

First of all, ensure that all the required technologies are properly installed and running. In the root directory of the project, execute:

```bash

$ rails server

```
#### Production deployment

Pending...
