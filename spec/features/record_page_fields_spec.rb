# frozen_string_literal: true

require "rails_helper"
require "yaml"
include ApplicationHelper

RSpec.feature "RecordPageFields" do
  let (:fixtures) {
    YAML.load_file("#{fixture_path}/features.yml")
  }

  feature "Purchase order link" do
    before do
      DatabaseCleaner.clean
      DatabaseCleaner.strategy = :truncation
      user = FactoryBot.build_stubbed :user
      allow(user).to receive(:can_purchase_order?) { can_purchase_order? }
      login_as user, scope: :user
    end

    let (:item) { fixtures.fetch("purchase_order") }
    let(:can_purchase_order?) { true }

    scenario "link appears one time" do
      visit "catalog/#{item['doc_id']}"
      expect(all("#purchase_order_button-991036931835603811").count).to eq(1)
    end
  end

  feature "long lists should be truncated" do
    let (:item) { fixtures.fetch("long_list") }

    scenario "items with more than 5 locations should be truncated with a more link" do
      visit  "catalog/#{item["doc_id"]}"
      expect(page).to have_css("td", text: "1960, pt.1", visible: true)
      expect(page).to have_css("td", text: "1965, pt.4", visible: false)
    end
  end

  feature "MARC Title Statement Fields" do
    let (:item) { fixtures.fetch("title_statement") }
    scenario "User visits a document with full title statement" do
      visit "catalog/#{item['doc_id']}"
      expect(page).to have_text(item["title_statement"])
    end

    scenario "User visits a document with title statement vernacular" do
      visit "catalog/#{item['doc_id']}"
      within "dd.blacklight-title_statement_vern_display" do
        expect(page).to have_text(item["title_statement_vern"])
      end
    end
  end

  feature "MARC Title Uniform Fields" do
      let (:item_130) { fixtures.fetch("title_uniform_130") }
      scenario "User visits a document with field 130 only" do
        visit "catalog/#{item_130['doc_id']}"
        within "dd.blacklight-title_uniform_display" do
          expect(page).to have_text(item_130["title_uniform"])
          expect(page).to have_link(item_130["title_uniform"])
        end
      end

      let (:item_240) { fixtures.fetch("title_uniform_240") }
      scenario "User visits a document with field 240 only" do
        visit "catalog/#{item_240['doc_id']}"
        within "dd.blacklight-title_uniform_display" do
          expect(page).to have_text(item_240["title_uniform"])
          expect(page).to have_link(item_240["title_uniform"])
        end
      end

      let (:item_730) { fixtures.fetch("title_uniform_730") }
      scenario "User visits a document with field 730 only" do
        visit "catalog/#{item_730['doc_id']}"
        within "dd.blacklight-title_uniform_display" do
          expect(page).to have_text("Subfield I.")
          expect(page).to have_link(item_730["title_uniform"])
        end
      end

      let (:item_130) { fixtures.fetch("title_uniform_130") }
      scenario "User visits a document with uniform title vernacular" do
          visit "catalog/#{item_130['doc_id']}"
          within "dd.blacklight-title_uniform_vern_display" do
              expect(page).to have_text(item_130["title_uniform_vern"])
            end
        end
    end

  feature "MARC Title Additional Fields" do
    let (:item_210) { fixtures.fetch("title_addl_210") }
    scenario "User visits a document with additional title " do
      visit "catalog/#{item_210['doc_id']}"
      within "dd.blacklight-title_addl_display" do
        expect(page).to have_text(item_210["title_addl"])
        expect(page).to have_link(item_210["title_addl"])
      end
    end

    let (:item_246) { fixtures.fetch("title_addl_246") }
    scenario "User visits a document with additional title " do
      visit "catalog/#{item_246['doc_id']}"
      within "dd.blacklight-title_addl_display" do
        expect(page).to have_text("Subfield I")
        expect(page).to have_link(item_246["title_addl"])
      end
    end

    let (:item_247) { fixtures.fetch("title_addl_247") }
    scenario "User visits a document with additional title " do
      visit "catalog/#{item_247['doc_id']}"
      within "dd.blacklight-title_addl_display" do
        expect(page).to have_text(item_247["title_addl"])
        expect(page).to have_link(item_247["title_addl"])
      end
    end

    let (:item_740) { fixtures.fetch("title_addl_740") }
    scenario "User visits a document with additional title " do
      visit "catalog/#{item_740['doc_id']}"
      within "dd.blacklight-title_addl_display" do
        expect(page).to have_text(item_740["title_addl"])
        expect(page).to have_link(item_740["title_addl"])
      end
    end

    let (:item_210) { fixtures.fetch("title_addl_210") }
    scenario "User visits a document with additional title vernacular" do
      visit "catalog/#{item_210['doc_id']}"
      within "dd.blacklight-title_addl_vern_display" do
        expect(page).to have_text(item_210["title_addl_vern"])
      end
    end
  end

  feature "MARC Creator Fields" do
    let (:item_100) { fixtures.fetch("creator_100") }
    scenario "User visits a document with creator" do
      visit "catalog/#{item_100['doc_id']}"
      within "dd.blacklight-creator_display" do
        expect(page).to have_text(item_100["creator"])
      end
    end

    let (:item_100_v) { fixtures.fetch("creator_100_v") }
    scenario "User visits a document with creator vernacular" do
      visit "catalog/#{item_100_v['doc_id']}"
      within "dd.blacklight-creator_vern_display" do
        expect(page).to have_text(item_100_v["creator_vern"])
      end
    end

    let (:item_110) { fixtures.fetch("creator_110") }
    scenario "User visits a document with creator" do
      visit "catalog/#{item_110['doc_id']}"
      within "dd.blacklight-creator_display" do
        expect(page).to have_text(item_110["creator"])
      end
    end

    let (:item_111) { fixtures.fetch("creator_111") }
    scenario "User visits a document with creator" do
      visit "catalog/#{item_111['doc_id']}"
      within "dd.blacklight-creator_display" do
        expect(page).to have_text(item_111["creator"])
      end
    end
  end

  feature "MARC Contributor Fields" do
    let (:item_700) { fixtures.fetch("contributor_700") }
    scenario "User visits a document with contributor" do
      visit "catalog/#{item_700['doc_id']}"
      within "dd.blacklight-contributor_display" do
        expect(page).to have_text(item_700["contributor"])
      end
    end

    let (:item_710) { fixtures.fetch("contributor_710") }
    scenario "User visits a document with contributor" do
      visit "catalog/#{item_710['doc_id']}"
      within "dd.blacklight-contributor_display" do
        expect(page).to have_text(item_710["contributor"])
      end
    end

    let (:item_711) { fixtures.fetch("contributor_711") }
    scenario "User visits a document with contributor" do
      visit "catalog/#{item_711['doc_id']}"
      within "dd.blacklight-contributor_display" do
        expect(page).to have_text(item_711["contributor"])
      end
    end

    let (:item_700_v) { fixtures.fetch("contributor_700_v") }
    scenario "User visits a document with contributor vernacular" do
      visit "catalog/#{item_700_v['doc_id']}"
      within "dd.blacklight-contributor_vern_display" do
        expect(page).to have_text(item_700_v["contributor_vern"])
      end
    end
  end

  feature "MARC Imprint Fields" do
    let (:item_260) { fixtures.fetch("imprint_260") }
    scenario "User visits a document with imprint" do
      visit "catalog/#{item_260['doc_id']}"
      within "dd.blacklight-imprint_display" do
        expect(page).to have_text(item_260["imprint"])
      end
    end

    let (:item_264_1) { fixtures.fetch("imprint_264_1") }
    scenario "User visits a document with imprint indicator2 value 1" do
      visit "catalog/#{item_264_1['doc_id']}"
      within "dd.blacklight-imprint_display" do
        expect(page).to have_text(item_264_1["imprint"])
      end
    end
  end

  feature "MARC Copyright notice date" do
    let (:item_260_year_only) { fixtures.fetch("imprint_260_year_only") }
    scenario "User visits a document including year only in subfield 'c'" do
      visit "catalog/#{item_260_year_only['doc_id']}"
      expect(page).to have_no_css("dd.blacklight-date_copyright_display")
    end

    let (:item_264) { fixtures.fetch("imprint_264") }
    scenario "User visits a document with date_copyright" do
      visit "catalog/#{item_264['doc_id']}"
      within "dd.blacklight-date_copyright_display" do
        expect(page).to have_text(item_264["date_copyright"])
      end
    end
  end

  feature "MARC Edition Fields" do
    let (:item_250) { fixtures.fetch("edition_250") }
    scenario "User visits a document with edition" do
      visit "catalog/#{item_250['doc_id']}"
      within "dd.blacklight-edition_display" do
        expect(page).to have_text(item_250["edition"])
      end
    end

    let (:item_254) { fixtures.fetch("edition_254") }
    scenario "User visits a document with edition" do
      visit "catalog/#{item_254['doc_id']}"
      within "dd.blacklight-edition_display" do
        expect(page).to have_text(item_254["edition"])
      end
    end
  end

  feature "MARC Physical Description Fields" do
    let (:item_300) { fixtures.fetch("phys_desc_300") }
    scenario "User visits a document with physical description" do
      visit "catalog/#{item_300['doc_id']}"
      within "dd.blacklight-phys_desc_display" do
        expect(page).to have_text(item_300["phys_desc"])
      end
    end

    let (:item_340) { fixtures.fetch("phys_desc_340") }
    scenario "User visits a document with physical description" do
      visit "catalog/#{item_340['doc_id']}"
      within "dd.blacklight-phys_desc_display" do
        expect(page).to have_text(item_340["phys_desc"])
      end
    end
  end

  feature "MARC Series Title Fields" do
    let (:item_830) { fixtures.fetch("title_series_830") }
    scenario "User visits a document with series title" do
      visit "catalog/#{item_830['doc_id']}"
      within "dd.blacklight-title_series_display" do
        expect(page).to have_text(item_830["title_series"])
      end
    end

    let (:item_490) { fixtures.fetch("title_series_490") }
    scenario "User visits a document with series title" do
      visit "catalog/#{item_490['doc_id']}"
      within "dd.blacklight-title_series_display" do
        expect(page).to have_text(item_490["title_series"])
      end
    end

    let (:item_440) { fixtures.fetch("title_series_440") }
    scenario "User visits a document with series title" do
      visit "catalog/#{item_440['doc_id']}"
      within "dd.blacklight-title_series_display" do
        expect(page).to have_text(item_440["title_series"])
      end
    end

    let (:item_800) { fixtures.fetch("title_series_800") }
    scenario "User visits a document with series title" do
      visit "catalog/#{item_800['doc_id']}"
      within "dd.blacklight-title_series_display" do
        expect(page).to have_text(item_800["title_series"])
      end
    end

    let (:item_810) { fixtures.fetch("title_series_810") }
    scenario "User visits a document with series title" do
      visit "catalog/#{item_810['doc_id']}"
      within "dd.blacklight-title_series_display" do
        expect(page).to have_text(item_810["title_series"])
      end
    end

    let (:item_811) { fixtures.fetch("title_series_811") }
    scenario "User visits a document with series title" do
      visit "catalog/#{item_811['doc_id']}"
      within "dd.blacklight-title_series_display" do
        expect(page).to have_text(item_811["title_series"])
      end
    end

    let (:item_830) { fixtures.fetch("title_series_830") }
    scenario "User visits a document with series title vernacular" do
      visit "catalog/#{item_830['doc_id']}"
      within "dd.blacklight-title_series_vern_display" do
        expect(page).to have_text(item_830["title_series_vern"])
      end
    end

    let (:item_490) { fixtures.fetch("title_series_490") }
    scenario "User visits a document with series title vernacular" do
      visit "catalog/#{item_490['doc_id']}"
      within "dd.blacklight-title_series_vern_display" do
        expect(page).to have_text(item_490["title_series_vern"])
      end
    end

    let (:item_440) { fixtures.fetch("title_series_440") }
    scenario "User visits a document with series title vernacular" do
      visit "catalog/#{item_440['doc_id']}"
      within "dd.blacklight-title_series_vern_display" do
        expect(page).to have_text(item_440["title_series_vern"])
      end
    end

    let (:item_800) { fixtures.fetch("title_series_800") }
    scenario "User visits a document with series title vernacular" do
      visit "catalog/#{item_800['doc_id']}"
      within "dd.blacklight-title_series_vern_display" do
        expect(page).to have_text(item_800["title_series_vern"])
      end
    end

    let (:item_810) { fixtures.fetch("title_series_810") }
    scenario "User visits a document with series title vernacular" do
      visit "catalog/#{item_810['doc_id']}"
      within "dd.blacklight-title_series_vern_display" do
        expect(page).to have_text(item_810["title_series_vern"])
      end
    end

    let (:item_811) { fixtures.fetch("title_series_811") }
    scenario "User visits a document with series title vernacular" do
      visit "catalog/#{item_811['doc_id']}"
      within "dd.blacklight-title_series_vern_display" do
        expect(page).to have_text(item_811["title_series_vern"])
      end
    end



  end

  feature "MARC Duration Fields" do
    let (:item_306) { fixtures.fetch("duration_306") }
    scenario "User visits a document with duration" do
      visit "catalog/#{item_306['doc_id']}"
      within "dd.blacklight-duration_display" do
        expect(page).to have_text(item_306["duration"])
      end
    end
  end

  feature "MARC Frequency Fields" do
    let (:item_310) { fixtures.fetch("frequency_310") }
    scenario "User visits a document with frequency" do
      visit "catalog/#{item_310['doc_id']}"
      within "dd.blacklight-frequency_display" do
        expect(page).to have_text(item_310["frequency"])
      end
    end

    let (:item_321) { fixtures.fetch("frequency_321") }
    scenario "User visits a document with frequency" do
      visit "catalog/#{item_321['doc_id']}"
      within "dd.blacklight-frequency_display" do
        expect(page).to have_text(item_321["frequency"])
      end
    end
  end

  feature "MARC Sound Fields" do
    let (:item_344) { fixtures.fetch("sound_344") }
    scenario "User visits a document with sound" do
      visit "catalog/#{item_344['doc_id']}"
      within "dd.blacklight-sound_display" do
        expect(page).to have_text(item_344["sound"])
      end
    end
  end

  feature "MARC Digital File Fields" do
    let (:item_347) { fixtures.fetch("digital_file_347") }
    scenario "User visits a document with digital file" do
      visit "catalog/#{item_347['doc_id']}"
      within "dd.blacklight-digital_file_display" do
        expect(page).to have_text(item_347["digital_file"])
      end
    end
  end

  feature "MARC Form Work Fields" do
    let (:item_380) { fixtures.fetch("form_work_380") }
    scenario "User visits a document with form work" do
      visit "catalog/#{item_380['doc_id']}"
      within "dd.blacklight-form_work_display" do
        expect(page).to have_text(item_380["form_work"])
      end
    end
  end

  feature "MARC Performance Fields" do
    let (:item_382) { fixtures.fetch("performance_382") }
    scenario "User visits a document with performance" do
      visit "catalog/#{item_382['doc_id']}"
      within "dd.blacklight-performance_display" do
        expect(page).to have_text(item_382["performance"])
      end
    end
  end

  feature "MARC Video File Fields" do
    let (:item_346) { fixtures.fetch("video_file_346") }
    scenario "User visits a document with video file" do
      visit "catalog/#{item_346['doc_id']}"
      within "dd.blacklight-video_file_display" do
        expect(page).to have_text(item_346["video_file"])
      end
    end
  end

  feature "MARC Music Format Fields" do
    let (:item_348) { fixtures.fetch("music_format_348") }
    scenario "User visits a document with music format" do
      visit "catalog/#{item_348['doc_id']}"
      within "dd.blacklight-music_format_display" do
        expect(page).to have_text(item_348["music_format"])
      end
    end
  end

  feature "MARC Music Key Fields" do
    let (:item_384) { fixtures.fetch("music_key_384") }
    scenario "User visits a document with music key" do
      visit "catalog/#{item_384['doc_id']}"
      within "dd.blacklight-music_key_display" do
        expect(page).to have_text(item_384["music_key"])
      end
    end
  end

  feature "MARC Audience Fields" do
    let (:item_385) { fixtures.fetch("audience_385") }
    scenario "User visits a document with audience" do
      visit "catalog/#{item_385['doc_id']}"
      within "dd.blacklight-audience_display" do
        expect(page).to have_text(item_385["audience"])
      end
    end
  end

  feature "MARC Creator Group Fields" do
    let (:item_386) { fixtures.fetch("creator_group_386") }
    scenario "User visits a document with creator_group" do
      visit "catalog/#{item_386['doc_id']}"
      within "dd.blacklight-creator_group_display" do
        expect(page).to have_text(item_386["creator_group"])
      end
    end
  end

  feature "MARC Date Period Fields" do
    let (:item_388) { fixtures.fetch("date_period_388") }
    scenario "User visits a document with date_period" do
      visit "catalog/#{item_388['doc_id']}"
      within "dd.blacklight-date_period_display" do
        expect(page).to have_text(item_388["date_period"])
      end
    end
  end

  feature "MARC Music No Fields" do
    let (:item_383) { fixtures.fetch("music_no_383") }
    scenario "User visits a document with music no" do
      visit "catalog/#{item_383['doc_id']}"
      within "dd.blacklight-music_no_display" do
        expect(page).to have_text(item_383["music_no"])
      end
    end
  end

  feature "MARC Note Fields" do
    let (:item_500) { fixtures.fetch("note_500") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_500['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_500["note"])
      end
    end

    let (:item_508) { fixtures.fetch("note_508") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_508['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_508["note"])
      end
    end

    let (:item_511) { fixtures.fetch("note_511") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_511['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_511["note"])
      end
    end

    let (:item_515) { fixtures.fetch("note_515") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_515['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_515["note"])
      end
    end

    let (:item_518) { fixtures.fetch("note_518") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_518['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_518["note"])
      end
    end

    let (:item_521) { fixtures.fetch("note_521") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_521['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_521["note"])
      end
    end

    let (:item_525) { fixtures.fetch("note_525") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_525['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_525["note"])
      end
    end

    let (:item_530) { fixtures.fetch("note_530") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_530['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_530["note"])
      end
    end

    let (:item_533) { fixtures.fetch("note_533") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_533['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_533["note"])
      end
    end

    let (:item_534) { fixtures.fetch("note_534") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_534['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_534["note"])
      end
    end

    let (:item_538) { fixtures.fetch("note_538") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_538['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_538["note"])
      end
    end

    let (:item_546) { fixtures.fetch("note_546") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_546['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_546["note"])
      end
    end

    let (:item_550) { fixtures.fetch("note_550") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_550['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_550["note"])
      end
    end

    let (:item_586) { fixtures.fetch("note_586") }
    scenario "User visits a document with note" do
      visit "catalog/#{item_586['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_text(item_586["note"])
      end
    end
  end

  feature "MARC Note With Fields" do
    let (:item_501) { fixtures.fetch("note_with_501") }
    scenario "User visits a document with note with" do
      visit "catalog/#{item_501['doc_id']}"
      within "dd.blacklight-note_with_display" do
        expect(page).to have_text(item_501["note_with"])
      end
    end
  end

  feature "MARC Note Diss Fields" do
    let (:item_502) { fixtures.fetch("note_diss_502") }
    scenario "User visits a document with note diss" do
      visit "catalog/#{item_502['doc_id']}"
      within "dd.blacklight-note_diss_display" do
        expect(page).to have_text(item_502["note_diss"])
      end
    end
  end

  feature "MARC Note Biblio Fields" do
    let (:item_504) { fixtures.fetch("note_biblio_504") }
    scenario "User visits a document with note biblio" do
      visit "catalog/#{item_504['doc_id']}"
      within "dd.blacklight-note_biblio_display" do
        expect(page).to have_text(item_504["note_biblio"])
      end
    end
  end

  feature "MARC Note Table of Contents Fields" do
    let (:item_505) { fixtures.fetch("note_toc_505") }
    scenario "User visits a document with note table of contents" do
      visit "catalog/#{item_505['doc_id']}"
      within "dd.blacklight-note_toc_display" do
        expect(page).to have_text(item_505["note_toc"])
      end
    end
  end

  feature "MARC Note Restrictions Fields" do
    let (:item_506) { fixtures.fetch("note_restrictions_506") }
    scenario "User visits a document with note restrictions" do
      visit "catalog/#{item_506['doc_id']}"
      within "dd.blacklight-note_restrictions_display" do
        expect(page).to have_text(item_506["note_restrictions"])
      end
    end
  end

  feature "MARC Note References Fields" do
    let (:item_510) { fixtures.fetch("note_references_510") }
    scenario "User visits a document with note references" do
      visit "catalog/#{item_510['doc_id']}"
      within "dd.blacklight-note_references_display" do
        expect(page).to have_text(item_510["note_references"])
      end
    end
  end

  feature "MARC Note Summary Fields" do
    let (:item_520) { fixtures.fetch("note_summary_520") }
    scenario "User visits a document with note summary" do
      visit "catalog/#{item_520['doc_id']}"
      within "dd.blacklight-note_summary_display" do
        expect(page).to have_text(item_520["note_summary"])
      end
    end
  end

  feature "MARC Note Cite Fields" do
    let (:item_524) { fixtures.fetch("note_cite_524") }
    scenario "User visits a document with note cite" do
      visit "catalog/#{item_524['doc_id']}"
      within "dd.blacklight-note_cite_display" do
        expect(page).to have_text(item_524["note_cite"])
      end
    end
  end

  feature "MARC Note Copyright Fields" do
    let (:item_540) { fixtures.fetch("note_copyright_540") }
    scenario "User visits a document with note copyright" do
      visit "catalog/#{item_540['doc_id']}"
      within "dd.blacklight-note_copyright_display" do
        expect(page).to have_text(item_540["note_copyright"])
      end
    end

    let (:item_542) { fixtures.fetch("note_copyright_542") }
    scenario "User visits a document with note copyright indicator 1 value unassigned" do
      visit "catalog/#{item_542['doc_id']}"
      within "dd.blacklight-note_copyright_display" do
        expect(page).to have_text(item_542["note_copyright"])
      end
    end

    let (:item_542_0) { fixtures.fetch("note_copyright_542_0") }
    scenario "User visits a document with note copyright indicator 1 value 0" do
      visit "catalog/#{item_542_0['doc_id']}"
      expect(page).to have_no_text(item_542_0["note_copyright"])
    end

    let (:item_542_1) { fixtures.fetch("note_copyright_542_1") }
    scenario "User visits a document with note copyright indicator 1 value 1" do
      visit "catalog/#{item_542_1['doc_id']}"
      within "dd.blacklight-note_copyright_display" do
        expect(page).to have_text(item_542_1["note_copyright"])
      end
    end
  end

  feature "MARC Note Bio Fields" do
    let (:item_545) { fixtures.fetch("note_bio_545") }
    scenario "User visits a document with note bio" do
      visit "catalog/#{item_545['doc_id']}"
      within "dd.blacklight-note_bio_display" do
        expect(page).to have_text(item_545["note_bio"])
      end
    end
  end

  feature "MARC Note Finding Aid Fields" do
    let (:item_555) { fixtures.fetch("note_finding_aid_555") }
    scenario "User visits a document with note finding aid" do
      visit "catalog/#{item_555['doc_id']}"
      within "dd.blacklight-note_finding_aid_display" do
        expect(page).to have_text(item_555["note_finding_aid"])
      end
    end
  end

  feature "MARC Note Custodial Fields" do
    let (:item_561) { fixtures.fetch("note_custodial_561") }
    scenario "User visits a document with note custodial" do
      visit "catalog/#{item_561['doc_id']}"
      within "dd.blacklight-note_custodial_display" do
        expect(page).to have_text(item_561["note_custodial"])
      end
    end
  end

  feature "MARC Note Binding Fields" do
    let (:item_563) { fixtures.fetch("note_binding_563") }
    scenario "User visits a document with note binding" do
      visit "catalog/#{item_563['doc_id']}"
      within "dd.blacklight-note_binding_display" do
        expect(page).to have_text(item_563["note_binding"])
      end
    end
  end

  feature "MARC Note Related Fields" do
    let (:item_580) { fixtures.fetch("note_related_580") }
    scenario "User visits a document with note related" do
      visit "catalog/#{item_580['doc_id']}"
      within "dd.blacklight-note_related_display" do
        expect(page).to have_text(item_580["note_related"])
      end
    end
  end

  feature "MARC Note Accruals Fields" do
    let (:item_584) { fixtures.fetch("note_accruals_584") }
    scenario "User visits a document with note accruals" do
      visit "catalog/#{item_584['doc_id']}"
      within "dd.blacklight-note_accruals_display" do
        expect(page).to have_text(item_584["note_accruals"])
      end
    end
  end

  feature "MARC Note Local Fields" do
    let (:item_590) { fixtures.fetch("note_local_590") }
    scenario "User visits a document with note local" do
      visit "catalog/#{item_590['doc_id']}"
      within "dd.blacklight-note_local_display" do
        expect(page).to have_text(item_590["note_local"])
      end
    end
  end

  feature "MARC Subject Fields" do
    let (:item_600) { fixtures.fetch("subject_600") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_600['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_600["subject"])
        expect(page).to have_text(" — ")
      end
    end

    let (:item_610) { fixtures.fetch("subject_610") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_610['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_610["subject"])
      end
    end

    let (:item_611) { fixtures.fetch("subject_611") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_611['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_611["subject"])
      end
    end

    let (:item_630) { fixtures.fetch("subject_630") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_630['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_630["subject"])
      end
    end

    let (:item_648) { fixtures.fetch("subject_648") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_648['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_648["subject"])
      end
    end

    let (:item_650) { fixtures.fetch("subject_650") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_650['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_650["subject"])
      end
    end

    let (:item_651) { fixtures.fetch("subject_651") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_651['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_651["subject"])
      end
    end

    let (:item_653) { fixtures.fetch("subject_653") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_653['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_653["subject"])
      end
    end

    let (:item_654) { fixtures.fetch("subject_654") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_654['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_654["subject"])
      end
    end

    let (:item_656) { fixtures.fetch("subject_656") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_656['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_656["subject"])
      end
    end

    let (:item_657) { fixtures.fetch("subject_657") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_657['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_657["subject"])
      end
    end

    let (:item_690) { fixtures.fetch("subject_690") }
    scenario "User visits a document with subject" do
      visit "catalog/#{item_690['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_text(item_690["subject"])
      end
    end
  end

  feature "Genre display fields" do
    let (:item_655) { fixtures.fetch("genre_655") }
    scenario "User visits a document with genre" do
      visit "catalog/#{item_655['doc_id']}"
      within "dd.blacklight-genre_ms" do
        expect(page).to have_text(item_655["genre"])
      end
    end
  end

  feature "Local Collection Fields" do
    let (:item_973a) { fixtures.fetch("collection_973_a") }
    scenario "User visits a document with collection 973a" do
      visit "catalog/#{item_973a['doc_id']}"
      within "dd.blacklight-collection_ms" do
        expect(page).to have_text(item_973a["collection"])
      end
    end

    let (:item_973t) { fixtures.fetch("collection_973_t") }
    scenario "User visits a document with collection 973t" do
      visit "catalog/#{item_973t['doc_id']}"
      within "dd.blacklight-collection_ms" do
        expect(page).to have_text(item_973t["collection"])
      end
    end
  end


  feature "MARC Entry Preced Fields" do
    let (:item_780_00) { fixtures.fetch("entry_preced_780_00") }
    scenario "User visits a document with continues" do
      visit "catalog/#{item_780_00['doc_id']}"
      within "dd.blacklight-continues_display" do
        expect(page).to have_text(item_780_00["continues"])
      end
    end

    let (:item_780_03) { fixtures.fetch("entry_preced_780_03") }
    scenario "User visits a document with continues_in_part" do
      visit "catalog/#{item_780_03['doc_id']}"
      within "dd.blacklight-continues_in_part_display" do
        expect(page).to have_text(item_780_03["continues_in_part"])
      end
    end

    let (:item_780_04) { fixtures.fetch("entry_preced_780_04") }
    scenario "User visits a document with formed_from" do
      visit "catalog/#{item_780_04['doc_id']}"
      within "dd.blacklight-formed_from_display" do
        expect(page).to have_text(item_780_04["formed_from"])
      end
    end

    let (:item_780_05) { fixtures.fetch("entry_preced_780_05") }
    scenario "User visits a document with absorbed" do
      visit "catalog/#{item_780_05['doc_id']}"
      within "dd.blacklight-absorbed_display" do
        expect(page).to have_text(item_780_05["absorbed"])
      end
    end

    let (:item_780_06) { fixtures.fetch("entry_preced_780_06") }
    scenario "User visits a document with absorbed_in_part" do
      visit "catalog/#{item_780_06['doc_id']}"
      within "dd.blacklight-absorbed_in_part_display" do
        expect(page).to have_text(item_780_06["absorbed_in_part"])
      end
    end

    let (:item_780_07) { fixtures.fetch("entry_preced_780_07") }
    scenario "User visits a document with separated_from" do
      visit "catalog/#{item_780_07['doc_id']}"
      within "dd.blacklight-separated_from_display" do
        expect(page).to have_text(item_780_07["separated_from"])
      end
    end
  end

  feature "MARC Entry Succeed Fields" do
    let (:item_785_00) { fixtures.fetch("entry_succeed_785_00") }
    scenario "User visits a document with continued_by" do
      visit "catalog/#{item_785_00['doc_id']}"
      within "dd.blacklight-continued_by_display" do
        expect(page).to have_text(item_785_00["continued_by"])
      end
    end

    let (:item_785_03) { fixtures.fetch("entry_succeed_785_03") }
    scenario "User visits a document with continued_in_part_by" do
      visit "catalog/#{item_785_03['doc_id']}"
      within "dd.blacklight-continued_in_part_by_display" do
        expect(page).to have_text(item_785_03["continued_in_part_by"])
      end
    end

    let (:item_785_04) { fixtures.fetch("entry_succeed_785_04") }
    scenario "User visits a document with absorbed_by" do
      visit "catalog/#{item_785_04['doc_id']}"
      within "dd.blacklight-absorbed_by_display" do
        expect(page).to have_text(item_785_04["absorbed_by"])
      end
    end

    let (:item_785_05) { fixtures.fetch("entry_succeed_785_05") }
    scenario "User visits a document with absorbed_in_part_by" do
      visit "catalog/#{item_785_05['doc_id']}"
      within "dd.blacklight-absorbed_in_part_by_display" do
        expect(page).to have_text(item_785_05["absorbed_in_part_by"])
      end
    end

    let (:item_785_06) { fixtures.fetch("entry_succeed_785_06") }
    scenario "User visits a document with split_into" do
      visit "catalog/#{item_785_06['doc_id']}"
      within "dd.blacklight-split_into_display" do
        expect(page).to have_text(item_785_06["split_into"])
      end
    end

    let (:item_785_07) { fixtures.fetch("entry_succeed_785_07") }
    scenario "User visits a document with merged_to_form_into" do
      visit "catalog/#{item_785_07['doc_id']}"
      within "dd.blacklight-merged_to_form_display" do
        expect(page).to have_text(item_785_07["merged_to_form"])
      end
    end

    let (:item_785_08) { fixtures.fetch("entry_succeed_785_08") }
    scenario "User visits a document with changed_back_to" do
      visit "catalog/#{item_785_08['doc_id']}"
      within "dd.blacklight-changed_back_to_display" do
        expect(page).to have_text(item_785_08["changed_back_to"])
      end
    end
  end

  feature "MARC Isbn Fields" do
    let (:item_020) { fixtures.fetch("isbn_020") }
    scenario "User visits a document with isbn" do
      visit "catalog/#{item_020['doc_id']}"
      within "dd.blacklight-isbn_display" do
        expect(page).to have_text(item_020["isbn"])
      end
    end
  end

  feature "MARC Issn Fields" do
    let (:item_022) { fixtures.fetch("issn_022") }
    scenario "User visits a document with issn" do
      visit "catalog/#{item_022['doc_id']}"
      within "dd.blacklight-issn_display" do
        expect(page).to have_text(item_022["issn"])
      end
    end
  end

  feature "MARC gpo Fields" do
    let (:item_074) { fixtures.fetch("gpo_074") }
    scenario "User visits a document with gpo" do
      visit "catalog/#{item_074['doc_id']}"
      within "dd.blacklight-gpo_display" do
        expect(page).to have_text(item_074["gpo"])
      end
    end
  end

  feature "MARC alma_mms Fields" do
    let (:item_001) { fixtures.fetch("alma_mms_001") }
    scenario "User visits a document with gpo" do
      visit "catalog/#{item_001['doc_id']}"
      within "dd.blacklight-alma_mms_display" do
        expect(page).to have_text(item_001["alma_mms"])
      end
    end
  end

  feature "MARC Pub No Fields" do
    let (:item_028) { fixtures.fetch("pub_no_028") }
    scenario "User visits a document with pub no" do
      visit "catalog/#{item_028['doc_id']}"
      within "dd.blacklight-pub_no_display" do
        expect(page).to have_text(item_028["pub_no"])
      end
    end
  end

  feature "MARC sudoc Fields" do
    let (:item_086) { fixtures.fetch("sudoc_086") }
    scenario "User visits a document with sudoc indicator1 value unassigned" do
      visit "catalog/#{item_086['doc_id']}"
      expect(page).to have_no_text(item_086["sudoc"])
    end

    let (:item_086_0) { fixtures.fetch("sudoc_086_0") }
    scenario "User visits a document with sudoc indicator1 value 0" do
      visit "catalog/#{item_086_0['doc_id']}"
      within "dd.blacklight-sudoc_display" do
        expect(page).to have_text(item_086_0["sudoc"])
      end
    end

    let (:item_086_1) { fixtures.fetch("sudoc_086_1") }
    scenario "User visits a document with udoc indicator1 value1" do
      visit "catalog/#{item_086_1['doc_id']}"
      expect(page).to have_no_text(item_086_1["sudoc"])
    end
  end

  feature "MARC Finding Aid Field" do
    let (:item_856_4) { fixtures.fetch("url_856_4") }
    scenario "User visits a document with url indicator1 value 4 indicator2 value2 and subfield u includes both http://library.temple.edu and scrc" do
      visit "catalog/#{item_856_4['doc_id']}"
      within "dd.blacklight-url_finding_aid_display" do
        expect(page).to have_text(item_856_4["url"])
        expect(page).to have_link("#{item_856_4['url']}", href: "#{item_856_4['url_href']}")
      end
    end
  end

  feature "MARC URL Fields" do
    let (:item_856_2) { fixtures.fetch("url_856_2") }
    scenario "User visits a document with url indicator2 value2" do
      visit "catalog/#{item_856_2['doc_id']}"
      within "dd.blacklight-url_more_links_display" do
        expect(page).to have_text(item_856_2["url"])
        expect(page).to have_link("#{item_856_2['url']}", href: "#{item_856_2['url_href']}")
      end
    end

    let (:item_856_more_1) { fixtures.fetch("url_856_more_1") }
    scenario "User visits a document with url indicator2 value1 text match" do
      visit "catalog/#{item_856_more_1['doc_id']}"
      within "dd.blacklight-url_more_links_display" do
        expect(page).to have_text(item_856_more_1["url"])
        expect(page).to have_link("#{item_856_more_1['url']}", href: "#{item_856_more_1['url_href']}")
      end
    end

    let (:item_856_more_3) { fixtures.fetch("url_856_more_3") }
    scenario "User visits a document with url indicator2 value2 with archive-it url in subfield u" do
      visit "catalog/#{item_856_more_3['doc_id']}"
      within "dd.blacklight-url_more_links_display" do
        expect(page).to have_text(item_856_more_3["url"])
        expect(page).to have_link("#{item_856_more_3['url']}", href: "#{item_856_more_3['url_href']}")
      end
    end
  end

  feature "MARC Language Fields" do
    let (:item) { fixtures.fetch("language") }
    scenario "User visits a document with entry language" do
      visit "catalog/#{item['doc_id']}"
      within "dd.blacklight-language_display" do
        expect(page).to have_text(item["language"])
      end
    end

    let (:item_jpn) { fixtures.fetch("language_jpn") }
    scenario "User visits a document with entry language other than English" do
      visit "catalog/#{item_jpn['doc_id']}"
      within "dd.blacklight-language_display" do
        expect(page).to have_text(item_jpn["language"])
      end
    end

    let (:item_041_a) { fixtures.fetch("language_041_a") }
    scenario "User visits a document with entry languages code specified in field 041" do
      visit "catalog/#{item_041_a['doc_id']}"
      within "dd.blacklight-language_display" do
        expect(page).to have_text(item_041_a["language"])
      end
    end

    let (:item_041_d) { fixtures.fetch("language_041_d") }
    scenario "User visits a document with entry languages code specified in field 041" do
      visit "catalog/#{item_041_d['doc_id']}"
      within "dd.blacklight-language_display" do
        expect(page).to have_text(item_041_d["language"])
      end
    end

    let (:item_041_e) { fixtures.fetch("language_041_e") }
    scenario "User visits a document with entry languages code specified in field 041" do
      visit "catalog/#{item_041_e['doc_id']}"
      within "dd.blacklight-language_display" do
        expect(page).to have_text(item_041_e["language"])
      end
    end

    let (:item_041_g) { fixtures.fetch("language_041_g") }
    scenario "User visits a document with entry languages code specified in field 041" do
      visit "catalog/#{item_041_g['doc_id']}"
      within "dd.blacklight-language_display" do
        expect(page).to have_text(item_041_g["language"])
      end
    end

    let (:item_041_j) { fixtures.fetch("language_041_j") }
    scenario "User visits a document with entry languages code specified in field 041" do
      visit "catalog/#{item_041_j['doc_id']}"
      within "dd.blacklight-language_display" do
        expect(page).to have_text(item_041_j["language"])
      end
    end
  end

  feature "MARC Format Field" do
    let (:item) { fixtures.fetch("simple_search") }
    scenario "User visits a document with format field" do
      visit "catalog/#{item['doc_id']}"
      within "dd.blacklight-format" do
        expect(page).to have_text(item["format"])
      end
    end
  end

  feature "Multiple value fields display as a list" do
    let (:note_500) { fixtures.fetch("note_500") }
    scenario "Has list of notes" do
      visit "catalog/#{note_500['doc_id']}"
      within "dd.blacklight-note_display" do
        expect(page).to have_css("li.list_items")
      end
    end

    let (:subject_600) { fixtures.fetch("subject_600") }
    scenario "Has list of subjects" do
      visit "catalog/#{subject_600['doc_id']}"
      within "dd.blacklight-subject_display" do
        expect(page).to have_selector("a")
      end
    end

    let (:language_041_a) { fixtures.fetch("language_041_a") }
    scenario "Has list of languages" do
      visit "catalog/#{language_041_a['doc_id']}"

      within "dd.blacklight-language_display" do
        expect(page).to have_text(language_041_a["language"])
      end
    end
  end

  feature "Links to search" do
    let (:item_100) { fixtures.fetch("creator_100") }
    scenario "Has link to creator" do
      visit "catalog/#{item_100['doc_id']}"
      expect(page).to have_link("#{item_100['creator_display']}")
    end

    let (:item_600) { fixtures.fetch("subject_600") }
    scenario "Has link to subject" do
      visit "catalog/#{item_600['doc_id']}"
      expect(page).to have_link("#{item_600['subject_display']}")
    end
  end

  feature "Multiple facet links" do
    scenario "Has multiple values in faceted show field" do
      visit "catalog/991012171319703811"
      within "dd.blacklight-subject_display" do
        href = page.find("li[2] a")["href"]
        expect(href).to eq("/catalog?f[subject_facet][]=Santa+Maria+Antiqua+%28Church+%3A+Rome%2C+Italy%29")
      end
    end
  end

  feature "Donor Information Fields" do
    let (:item_541) { fixtures.fetch("donor_info_541") }
    scenario "User visits a document with field 541" do
      visit "catalog/#{item_541['doc_id']}"
      within "dd.blacklight-donor_info_ms" do
        expect(page).to have_text(item_541["donor_name"])
        expect(page).to have_link(item_541["donor_name"])
      end
    end
  end
end
