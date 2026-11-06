# frozen_string_literal: true

require "rails_helper"
require "tmpdir"

class TestGeneratorArchive < ActiveSupport::TestCase
  def test_compress_pass_file_preserves_binary_contents
    FileUtils.mkdir_p(Passkit::Generator::TMP_FOLDER)

    Dir.mktmpdir("passkit-generator-", Passkit::Generator::TMP_FOLDER) do |directory|
      source = Pathname.new(directory)
      files = {
        "pass.json" => '{"description":"Zoo membership"}',
        "manifest.json" => '{"pass.json":"checksum"}',
        "signature" => "\x00\xFF\x80".b,
        "icon.png" => "\x89PNG\r\n\x1A\n".b
      }
      files.each { |name, contents| File.binwrite(source.join(name), contents) }

      pass = Struct.new(:generator, :file_name).new(nil, source.basename.to_s)
      generator = Passkit::Generator.new(pass)
      generator.instance_variable_set(:@temporary_path, source)

      archive_path = generator.send(:compress_pass_file)

      begin
        assert_equal Passkit::Generator::TMP_FOLDER.join("#{pass.file_name}.pkpass"), archive_path
        Zip::File.open(archive_path) do |archive|
          assert_equal files.keys.sort, archive.entries.map(&:name).sort
          files.each do |name, contents|
            assert_equal contents.b, archive.read(name).b, "#{name} contents changed"
          end
        end
      ensure
        FileUtils.rm_f(archive_path)
      end
    end
  end
end
