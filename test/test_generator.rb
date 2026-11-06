# frozen_string_literal: true

require "rails_helper"

class ExpiringStoreCard < Passkit::ExampleStoreCard
  def expiration_date
    "2030-01-01T23:59:59-05:00"
  end

  def pass_path
    File.expand_path("../lib/passkit/example_store_card", __dir__)
  end
end

class TestGenerator < ActiveSupport::TestCase
  def test_includes_expiration_date_when_the_pass_has_one
    json = generate_pass_json("ExpiringStoreCard")

    assert_equal "2030-01-01T23:59:59-05:00", json["expirationDate"]
  end

  def test_omits_expiration_date_when_the_pass_has_none
    json = generate_pass_json("Passkit::ExampleStoreCard")

    refute json.key?("expirationDate")
  end

  private

  def generate_pass_json(klass)
    pass = Passkit::Pass.create!(klass: klass)
    generator = Passkit::Generator.new(pass)
    generator.send(:create_temporary_directory)
    generator.send(:copy_pass_to_tmp_location)
    generator.send(:generate_json_pass)

    JSON.parse(File.read(generator.instance_variable_get(:@temporary_path).join("pass.json")))
  end
end
