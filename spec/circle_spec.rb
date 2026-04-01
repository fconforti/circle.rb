# frozen_string_literal: true

RSpec.describe Circle do
  it "has a version number" do
    expect(Circle::VERSION).not_to be_nil
  end

  describe ".configure" do
    it "yields a configuration object" do
      Circle.configure do |config|
        config.api_key = "my-key"
        config.base_url = "https://custom.example.com"
      end

      expect(Circle.configuration.api_key).to eq("my-key")
      expect(Circle.configuration.base_url).to eq("https://custom.example.com")
    end
  end

  describe ".reset_configuration!" do
    it "resets to defaults" do
      Circle.configure { |c| c.api_key = "old-key" }
      Circle.reset_configuration!

      expect(Circle.configuration.api_key).to be_nil
      expect(Circle.configuration.base_url).to eq("https://api.circle.com")
    end
  end
end
