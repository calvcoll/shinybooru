# Shinybooru

A gem which returns an easy to use object for Gelbooru requests

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shinybooru'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shinybooru

## Usage

###Creating Booru object
```ruby
booru = Shinybooru::Booru.new
```

###Retrieving posts from Gelbooru server
```ruby
booru = Shinybooru::Booru.new
post = booru.posts 1 #returns Shinybooru::Post
```

###Retrieving posts from Gelbooru server
```ruby
booru = Shinybooru::Booru.new
posts = booru.posts 10 #returns Array of Shinybooru::Post
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/calvcoll/shinybooru.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

