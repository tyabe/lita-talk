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

        context, mode = redis.hmget(:session, 'context', 'mode')
        log.debug "contxt: #{context}, mode: #{mode}"
        dialogue = client.create_dialogue(message, context: context, mode: mode)

        if dialogue.body["requestError"]
          response.reply_with_mention(dialogue.body["requestError"])
        else
          redis.hmset(:session, "context", dialogue.body["context"], "mode", dialogue.body["mode"])
          redis.expire(:session, 12)
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
