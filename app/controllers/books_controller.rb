class BooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    KafkaMessageProducer.publish(params.permit(:title, :author).to_h)
    render json: { status: 'Message sent to Kafka' }, status: :ok
  end
end

