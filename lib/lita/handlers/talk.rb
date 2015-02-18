require 'docomoru'

module Lita
  module Handlers
    class Talk < Handler

      config :docomo_api_key, type: String, required: true
      config :parsing_error_message, type: String
      config :error_message, type: String

      on :unhandled_message, :talk

      def talk(payload)
        response = payload[:message]
        return unless response.command?

        message = payload[:message].body

        dialogue = client.create_dialogue(message, context: @context)

        if dialogue.body["requestError"]
          response.reply_with_mention(dialogue.body["requestError"])
        else
          @context = dialogue.body["context"]
          response.reply_with_mention(dialogue.body["utt"])
        end
      rescue Faraday::ParsingError => e
        log.error(%<Error: #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}>)
        response.reply_with_mention(config.parsing_error_message || e.message )
      rescue => e
        log.error(%<Error: #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}>)
        response.reply_with_mention(config.error_message || e.message )
      end

      private

      def client
        @client ||= Docomoru::Client.new(api_key: config.docomo_api_key)
      end
    end

    Lita.register_handler(Talk)
  end
end
