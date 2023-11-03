module Passkit
  module Dashboard
    class LogsController < Passkit::Dashboard::ApplicationController
      def index
        @logs = Passkit::Log.order(created_at: :desc).first(100)
      end
    end
  end
end
