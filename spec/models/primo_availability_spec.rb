# frozen_string_literal: true

require "rails_helper"

RSpec.describe PrimoAvailability, type: :model  do
  let(:valid_base_url) { "https://temple.services.exlibrisgroup.com/foo" }
  let(:valid_pa) { described_class.new(base_url: valid_base_url) }

  describe "validating the base_url" do
    it "raises an error when given no base_url is supplied" do
      expect { described_class.new() }.to raise_error(ActiveModel::ValidationError)
    end
    it "raises an error when provided a base_url with an unexpected host" do
      expect { described_class.new(base_url: "https://google.com") }.to raise_error(ActiveModel::ValidationError)
    end
    it "does not raises an error when provided the expected base_url" do
      expect { valid_pa }.not_to raise_error
    end
  end

  describe "#url method" do
    it "appends '&is_new_ui=true' to the base_url when not present" do
      expect(valid_pa.url).to include("&is_new_ui=true")
    end
    it "does not double append '&is_new_ui=true' to the base_url when already present" do
      url = "https://temple.services.exlibrisgroup.com/foo&is_new_ui=true"
      pa = described_class.new(base_url: url)
      expect(pa.url.scan("&is_new_ui=true").size).to equal(1)
    end
  end

  describe "#get_html_or_raise_error" do
    let(:get_html_or_raise_error) { valid_pa.get_html_or_raise_error }
    it "raises an error on timeout" do
      stub_request(:get, /temple\.services\.exlibrisgroup\.com/).to_timeout
      expect { get_html_or_raise_error }.to raise_error(described_class::HTTPGetError)
    end

    it "raises an error on unsuccessful request" do
      stub_request(:get, /temple\.services\.exlibrisgroup\.com/).
        to_return(status: [500, "Internal Server Error"])
      expect { get_html_or_raise_error }.to raise_error(described_class::HTTPGetError, /Internal Server Error/)
    end

    describe "successful request" do
      html = "<html>test</html>"
      it "does not error on a successful request" do
        stub_request(:get, /temple\.services\.exlibrisgroup\.com/).
          to_return(body: html)
        expect { get_html_or_raise_error }.not_to raise_error
      end
      it "returns the expected html on sucessful request" do
        stub_request(:get, /temple\.services\.exlibrisgroup\.com/).
          to_return(body: html)
        expect(get_html_or_raise_error).to eql(html)
      end
    end
  end
end
