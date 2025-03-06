class KafkaProducer
  TOPIC = 'books'.freeze

  def self.publish(message)
    kafka = Rails.application.config.kafka_producer
    producer = kafka.async_producer(
      delivery_interval: 5 # Adjust as needed
    )

    producer.produce(message.to_json, topic: TOPIC)
    producer.deliver_messages
  ensure
    producer.shutdown if producer
  end
end

