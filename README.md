
# MeFirst

A straighforward extension for ActiveRecord models which makes it easy to reorder objects by a given column's values. 

![lemon-line](http://dl.dropboxusercontent.com/s/kuwpzbcz5659umh/lemon-line.gif?dl=0)

## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'me_first'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install me_first

## Usage

### Installation

To use MeFirst, you need to:

1. Add an `integer` ordering column to your model.
2. Require MeFirst in your model.
3. Use MeFirst's `attr_orderable` method with the ordering column as an argument. 

So:

```bash
$ rails g migration add_column_order_to_fake_models order:integer
$ rake db:migrate
```

```ruby
class FakeModel
    include MeFirst
    attr_orderable :order
end
```

That's it! You're now ready to reorder by `order` (or whichever column name you want) at will.


### Commands

MeFirst gives you a number of commands, named based on the given column. For the above example, you're given two scopes:

```ruby
FakeModel.by_order
FakeModel.by_reverse_order
```

And a number of useful instance methods:

```ruby
instance = FakeModel.first
instance.move_order_up!(2) # Moves the instance's order up by 2 places
instance.move_order_down!(1) # Moves the instance's order down by 1 place
instance.move_order_to_end!
instance.move_order_to_beginning!
instance.set_order!(5) # Sets the current instance's order to 5, and reorders other instances around it.
```

Note that these methods are all dependent upon the column name:

```ruby
class FakeModel
    include MeFirst
    attr_orderable :position
end

FakeModel.by_position
FakeModel.first.move_position_up!(5)
```


### Performance Note

This works great for relatively small numbers of objects. When dealing with a large table of ordered objects, MeFirst (and ordering by column in general), will not be particularly performant -- resetting a single instance's order requires changing the order of all the objects which followed its initial location. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/sashafklein/me_first/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
