Geocoder.configure(
  # Geocoding options
  timeout:      7,           # geocoding service timeout (secs)
  lookup:       :google,     # name of geocoding service (symbol)
  ip_lookup:    (ENV['GEOCODER_IP_ADDRESS_SERVICE'] || 'ipapi_com').to_sym,
  language:     :en,         # ISO-639 language code
  use_https:    true,        # use HTTPS for lookup requests? (if supported)
  http_proxy:   '',          # HTTP proxy server (user:pass@host:port)
  https_proxy:  '',          # HTTPS proxy server (user:pass@host:port)
  api_key:      nil,         # API key for geocoding service
  cache:        nil,         # cache object (must respond to #[], #[]=, and #keys)
  cache_prefix: "geocoder:", # prefix (string) to use for all cache keys
)
