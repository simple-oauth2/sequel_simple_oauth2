# Sequel SimpleOAuth2

## Installation

Add this line to your application's *Gemfile:*

```ruby
gem 'sequel_simple_oauth2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_simple_oauth2

## Usage

*OAuth2* workflow implies the existence of the next four roles: **Access Token**, **Access Grant**, **Application** and **Resource Owner**. The gem needs to know what classes work, so you need to create them, and also you need to **configure** [Simple::OAuth2](https://github.com/simple-oauth2/simple_oauth2).

Your project must include 4 models - *AccessToken*, *AccessGrant*, *Client* and *User* **for example**. These models must contain a specific set of API (methods). So everything that you need, it just include each `mixin` to specific class.

***AccessToken*** class:
```ruby
  # app/models/access_token.rb

  class AccessToken
    include Sequel::Simple::OAuth2::AccessToken
  end
```

***AccessGrant*** class:
```ruby
  # app/models/access_grant.rb

  class AccessGrant
    include Sequel::Simple::OAuth2::AccessGrant
  end
```

***Client*** class:
```ruby
  # app/models/client.rb

  class Client
    include Sequel::Simple::OAuth2::Client
  end
```

***User*** class:
```ruby
  # app/models/user.rb

  class User
    include Sequel::Simple::OAuth2::ResourceOwner
  end
```

Migration for the simplest use case of the gem looks as follows: [example](https://github.com/simple-oauth2/sequel_simple_oauth2/tree/master/db/migrations/1_schema.rb)

And that's it.
Also you can take a look at the [mixins](https://github.com/simple-oauth2/sequel_simple_oauth2/tree/master/lib/sequel_simple_oauth2/mixins) to understand what they are doing and what they are returning.

## Bugs and Feedback

Bug reports and feedback are welcome on GitHub at https://github.com/simple-oauth2/sequel_simple_oauth2/issues.

## Contributing

1. Fork the project.
1. Create your feature branch (`git checkout -b my-new-feature`).
1. Implement your feature or bug fix.
1. Add documentation for your feature or bug fix.
1. Add tests for your feature or bug fix.
1. Run `rake` and `rubocop` to make sure all tests pass.
1. Commit your changes (`git commit -am 'Add new feature'`).
1. Push to the branch (`git push origin my-new-feature`).
1. Create new pull request.

Thanks.

## License

The gem is available as open source under the terms of the [MIT License](https://github.com/simple-oauth2/sequel_simple_oauth2/blob/master/LICENSE).

Copyright (c) 2018 Volodimir Partytskyi (volodimir.partytskyi@gmail.com).
