class KafkaMessageProducer
  TOPIC = "#{ENV['KAFKA_PREFIX']}books".freeze

  def self.publish(message)
    # Get Kafka URLs from Heroku environment
    kafka_urls = ENV['KAFKA_URL'].split(',')

    # Remove 'kafka+ssl://' prefix for compatibility with ruby-kafka
    kafka_brokers = kafka_urls.map { |url| url.sub(/^kafka\+ssl:\/\//, '') }

    # Kafka Client Configuration with SSL
    kafka = Kafka.new(
      kafka_brokers,
      client_id: "producer_app",
      ssl_ca_cert: ENV['KAFKA_TRUSTED_CERT'],        # SSL CA Certificate
      ssl_client_cert: ENV['KAFKA_CLIENT_CERT'],     # SSL Client Certificate
      ssl_client_cert_key: ENV['KAFKA_CLIENT_CERT_KEY'], # SSL Client Key
      ssl_verify_hostname: false  # <-- Disable hostname verification
    )

    producer = kafka.async_producer(
      delivery_interval: 5 # Adjust as needed
    )

    producer.produce(message.to_json, topic: TOPIC)
    producer.deliver_messages
  ensure
    producer.shutdown if producer
  end
end

