# Possimatch

Simple matching 'gem' from two source to get the best match based on defined rules

## Installation

Add this line to application's Gemfile:

```ruby
gem 'possimatch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install possimatch

## Usage

First we need to install the Possimatch into our application.

	rails g possimatch:install

It will generates 3 migrations and 1 initializer files

	db/migrate/
	create_possi_matches.rb
	create_possi_resources.rb
	create_possi_rules.rb

	config/initializers
	possimatch.rb

Don't forget to run migrations to get the possimatch tables

	rake db:migrate

Next, we need generate the resource for the matchings system. Let's say we want to create matching suggestion from list of customers to list of vendors in company.
First we need to create the resources for all companies.

rails g possimatch:resource(class_name, from_class, to_class, group_key)

	rails g possimatch:resource company customer vendor company_id

class_name => we use company as our resource
from_class => we want to match from customers data
to_class   => to vendors data
group_key  => key that belongs to customer and vendor as the group key

It will generate 2 files:

	app/models/
	possi_match.rb
	possi_company.rb

After we get the model PossiCompany, next thing to do is create default resources and default rules in console

	rails console

After get into rails console, all we need to do is type these line to create the default resources and it will create the resources into table possi_resources for each companies.
	
	> PossiCompany.create_default_resource

*NOTE*
*for now, can only match data with type date/decimal*

To run the matching system, we need to setup at least 1 rule. for example: we want to match the customer's balance with vendor's balance.

	> PossiCompany.create_default_rule(from_source_field, to_source_field, data_type, margin)

from_source_field 	=> 'height' field name in customers table
to_source_field		=> 'height' field name in vendors tables
data_type			=> 'decimal'
margin				=> 0 (error margin 0 = must match 100%, 10 = height +- 10)

## Development

Under construction

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ferydjzz/possimatch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

