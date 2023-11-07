module Passkit
  class Factory
    class << self
      def create_pass(pass_class, generator = nil, additional_params = {})
        pass = Passkit::Pass.create!(klass: pass_class, generator: generator, additional_params: additional_params)
        Passkit::Generator.new(pass).generate_and_sign
      end
    end
  end
end
