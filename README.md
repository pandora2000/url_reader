# Description

Ruby module to read url for html, text or image with cache.

# Usage

```
require 'url_reader'

include UrlReader

read_url('https://www.google.co.jp/')

# => "<!doctype html><html itemscope=\"\"...
```

# Cache

If `defined?(Rails) && Rails.env.development?` then cache is used.

# Image

UrlReader detect image for Content Type matching `/^image\//`. You can set `image_content_type` option for additional Content Type for image.

# Options

- `headers` Set HTTP headers
- `user_agent` Set User Agent
- `cookies` Set Cookies
- `timeout` Set request timeout
- `open_timeout` Set request open timeout
- `method` Set HTTP method
- `ignore_errors` Set ignored errors
- `ignore_not_found` Set to ignore 404
- `ignore_server_error` Set to ignore 503
- `params` Set parameters for POST

# Class attributes

- `last_response_headers` Get last response HTTP headers
- `last_response_cookies` Get last response Cookies
- `last_cache_used` Get cache was used or not last time
