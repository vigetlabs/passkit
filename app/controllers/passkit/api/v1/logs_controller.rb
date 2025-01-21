module Passkit
  module Api
    module V1
      class LogsController < ActionController::API
        def create
          params[:logs].each do |message|
            Log.create!(content: message)

            log(message)
          end
          render json: {}, status: :ok
        end

        private

        def log(msg)
          apple_wallet_log.info(msg)
        end

        def apple_wallet_log
          @order_processor_log ||= Logger.new("log/#{Rails.env}_apple_wallet_log.log")
        end
      end
    end
  end
end
