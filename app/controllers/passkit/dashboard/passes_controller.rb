module Passkit
  module Dashboard
    class PassesController < Passkit::Dashboard::ApplicationController
      def index
        @passes = Passkit::Pass.order(created_at: :desc).includes(:devices).first(100)
      end
    end
  end
end
