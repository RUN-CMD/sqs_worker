require 'sqs_worker/signal_handler'

module SqsWorker
  class Batcher
    include Celluloid
    include SqsWorker::SignalHandler

    def initialize(manager:, processor:)
      @manager = manager
      @processor = processor
      subscribe_for_signals
    end

    def process(messages)

      successful_messages = []

      unless stopping?

        processed_results = messages.to_a.map { |message| processor.future.process(message) }

        manager.batch_done(messages)

        #processed_results.each do |result|
          #log "Error occured processing message: #{result.value[:message]}" unless result.value[:success]
        #end
      end
    end

    private

    attr_reader :manager, :processor

  end

end
