require_relative "boot"

require "rails/all"
require "kafka"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KafkaProducer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Setup Kafka producer
    kafka_brokers = ENV["KAFKA_URL"].split(",")

    config.kafka_producer = Kafka.new(
      seed_brokers: ENV.fetch('KAFKA_URL').split(','),
      ssl_client_cert: OpenSSL::X509::Certificate.new(ENV['KAFKA_CLIENT_CERT']),
      ssl_client_cert_key: OpenSSL::PKey::RSA.new(ENV['KAFKA_CLIENT_CERT_KEY']),
      ssl_ca_cert: OpenSSL::X509::Certificate.new(ENV['KAFKA_TRUSTED_CERT']),
      ssl_verify_hostname: false  # <--- Disable hostname verification
    )
  end
end
