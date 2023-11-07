module Passkit
  class PayloadGenerator
    VALIDITY = 30.days

    def self.encrypted(pass_class, generator = nil, additional_params = {})
      UrlEncrypt.encrypt(hash(pass_class, generator, additional_params))
    end

    def self.hash(pass_class, generator = nil, additional_params = {})
      valid_until = VALIDITY.from_now

      {valid_until: valid_until,
       generator_class: generator&.class&.name,
       generator_id: generator&.id,
       pass_class: pass_class.name,
       additional_params: additional_params}
    end
  end
end
