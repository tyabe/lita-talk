# lita-talk

lita-talk is a Lita handler that to talk with lita.
Use of docomo dialogue api.

## Installation

Add lita-talk to your Lita instance's Gemfile:

``` ruby
gem "lita-talk"
```

## Configuration

```ruby
Lita.configure do |config|
...
  config.handlers.talk.docomo_api_key = ENV["DOCOMO_API_KEY"]
...
end
```

## Usage

`Lita: こんにちは`

## License

[MIT](http://opensource.org/licenses/MIT)
