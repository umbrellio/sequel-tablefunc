# Sequel::Tablefunc

This is sequel extension that makes using crosstab function more convenient


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sequel-tablefunc', github: 'fiscal-cliff/sequel-tablefunc'
```

And then execute:

    $ bundle

## Usage

Assuming you have table which already have 2 categories. This table can be represented as a pivot table

```ruby
  User.select_group(:type_id, :status_id).select_append(:count.sql_function('*'.lit)).order(:type_id).crosstab(User.select(:status_id).distinct.order(:status_id)).all
```

| row_name     | status1     | status2 |
| :------------- | :------------- | :------------- |
| type1      | 5       | 10|
| :------------- | :------------- | :------------- |
| type2      | 1       | 2|

It is easy, isn't it?

```ruby
  User.select_group(:date_trunc.sql_function('year', :created_at), :status_id).select_append(:count.sql_function('*'.lit)).order(:date_trunc.sql_function('year', :created_at)).crosstab(User.select(:status_id).distinct.order(:status_id)).all
```

| row_name     | status1     | status2 |
| :------------- | :------------- | :------------- |
| 2012-01-01 00:00:00      | 6       | nil|
| :------------- | :------------- | :------------- |
| 2013-01-01 00:00:00      | nil       | 12|

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fiscal-cliff/sequel-tablefunc.
