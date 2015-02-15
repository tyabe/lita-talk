require 'docomoru'

module Lita
  module Handlers
    class Talk < Handler

      config :docomo_api_key, type: String, required: true

      on :unhandled_message, :talk

      def talk(payload)
        response = payload[:message]
        message = payload[:message].body

        dialogue = client.create_dialogue(message, context: @context)

        if dialogue.body["requestError"]
          response.reply(dialogue.body["requestError"])
        else
          @context = dialogue.body["context"]
          response.reply(dialogue.body["utt"])
        end
      rescue Exception => e
        log.error(%<Error: #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}>)
        response.reply(e.message)
      end

      private

      def client
        @client ||= Docomoru::Client.new(api_key: config.docomo_api_key)
      end
    end

    Lita.register_handler(Talk)
  end
end
