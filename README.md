![Ruby](https://github.com/mashirozx/omniauth-gitee/workflows/Ruby/badge.svg?branch=master)

# OmniAuth Gitee (码云)

码云 OmniAuth 策略。

This is the OmniAuth strategy for authenticating to Gitee. To
use it, you'll need to sign up for an OAuth2 Application ID and Secret
on the [Gitee Applications Page](https://gitee.com/oauth/applications).

Forked and modified from [omniauth-github](https://github.com/omniauth/omniauth-github)

## Installation

```ruby
gem 'omniauth-gitee', github: 'mashirozx/omniauth-gitee', branch: 'master'
# or
gem 'omniauth-gitee', '~> 1.0.0'
```

## Basic Usage

```ruby
use OmniAuth::Builder do
  provider :gitee, ENV['GITEE_KEY'], ENV['GITEE_SECRET']
end
```


## Basic Usage Rails

In `config/initializers/gitee.rb`

```ruby
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :gitee, ENV['GITEE_KEY'], ENV['GITEE_SECRET']
  end
```

## Scopes

Gitee API v5 lets you set scopes to provide granular access to different types of data: 

```ruby
use OmniAuth::Builder do
  provider :gitee, ENV['GITEE_KEY'], ENV['GITEE_SECRET'], scope: "user_info emails"
end
```

More info on [docs](https://gitee.com/api/v5/oauth_doc#/).


## Semver
This project adheres to Semantic Versioning 1.0.0. Any violations of this scheme are considered to be bugs. 
All changes will be tracked [here](https://github.com/mashirozx/omniauth-gitee/releases).

## License

Copyright (c) 2022 Mashiro (github.com/mashirozx)  
Copyright (c) 2011 Michael Bleigh and Intridea, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
