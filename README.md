# Smugsyncv2

API Client for the SmugMug v2 api

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'smugsyncv2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smugsyncv2

## Requirements

### Obtain an API key
Currently, you must have an api key to use the API client.  You can apply for one by visiting https://api.smugmug.com/api/developer/apply.

## Usage

### Download images by tag
```bash
smugsyncv2 download --key=smugmug_api_key --secret=smugmug_api_secret_key --tags=tag1 tag2 --dest=~/Downloads/myimages
```

### Exercising the API directly
```ruby
client = Smugsyncv2::Client.new('smugmug_api_key', 'smugmug_api_secret_key')
client.user
albums = client.get_uri('UserAlbums')
albums.Response.Album.first.NiceName
```

## Contributing

1. Fork it ( https://github.com/devkmsg/smugsyncv2/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
