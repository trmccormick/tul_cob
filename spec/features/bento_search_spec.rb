# frozen_string_literal: true

require "rails_helper"
require "yaml"

RSpec.feature "Bento Searches" do
  let (:fixtures) {
    YAML.load_file("#{fixture_path}/search_features.yml")
  }
  feature "Search all fields" do
    let (:item) { fixtures.fetch("book_search") }
    scenario "Search Title" do
      visit "/bento"
      within("div.input-group") do
        fill_in "q", with: item["title"]
        VCR.use_cassette("bento_search_features", record: :none, match_requests_on: [:host, :path]) {
          click_button
        }
      end
      within first("h3") do
        expect(page).to have_text item["title"]
      end
    end
  end

  feature "Blacklight link to full results" do
    let (:item) { fixtures.fetch("book_search") }
    scenario "Blacklight results display link to full results " do
      visit "/bento"
      within("div.input-group") do
        fill_in "q", with: item["title"]
        VCR.use_cassette("bento_search_features", record: :none, match_requests_on: [:host, :path]) {
          click_button
        }
      end
      within first("div.bento-search-engine") do
        expect(page).to have_css("a.bento-full-results")

        within first("div.document-metadata") do
          expect(page).not_to have_css("span.index-label")
        end
      end

    end
  end

  feature "Search Field dropdown should not appear in bento view" do
    it "does not have a search field dropdown menu" do
      visit "/"
      expect(page).to_not have_css("#search_field")
    end
  end
end
