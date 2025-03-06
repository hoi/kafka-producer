require 'kafka'

kafka_url = ENV['KAFKA_URL'] || 'localhost:9092'

Rails.application.config.kafka_producer = Kafka.new([kafka_url], client_id: "rails_app")

