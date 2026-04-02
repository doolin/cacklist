# In production, set SECRET_KEY_BASE environment variable.
# For development and test, Rails uses config/master.key or this fallback.
unless Rails.env.production?
  Rails.application.config.secret_key_base =
    '43b751b8f2ba6a28ff971b7242ab45b152b5b45360abdefd3150604112f3ae42' \
    'b09aaca099193dd4513b2b8398ed367b3d9f5287201f4f776b348d150090fe74'
end
