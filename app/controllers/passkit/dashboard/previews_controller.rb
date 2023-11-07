module Passkit
  module Dashboard
    class PreviewsController < Passkit::Dashboard::ApplicationController
      def index
      end

      def show
        builder = Passkit.configuration.available_passes[params[:class_name]]
        if Passkit.configuration.additional_params.has_key?(params[:class_name])
          additional_params = Passkit.configuration.additional_params[params[:class_name]]
        else
          additional_params = {}
        end

        path = Factory.create_pass(params[:class_name].constantize, builder.call, additional_params)

        send_file path, type: "application/vnd.apple.pkpass", disposition: "attachment", filename: "pass.pkpass"
      end
    end
  end
end
