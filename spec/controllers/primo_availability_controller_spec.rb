# frozen_string_literal: true

require "rails_helper"

RSpec.describe PrimoAvailabilityController, type: :controller do
  describe "provided bad data" do
    it "returns a 500" do
      get(:show, params: {url: "http://google.com"})
      expect(response.status).to eq(500) 
    end
  end
end
