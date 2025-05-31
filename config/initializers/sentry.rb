# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = 'https://ffbe6ced00034c0faac0888e343fb29d@o4509152856047616.ingest.de.sentry.io/4509413466767440'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  config.send_default_pii = true
end
