# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchController, type: :controller do

  describe "#process_results" do
    let(:results) { BentoSearch::ConcurrentSearcher.new(:books_and_media, :cdm).search("foo").results }

    before {
      stub_request(:get, /contentdm/)
        .to_return(status: 200,
                  headers: { "Content-Type" => "application/json" },
                  body: JSON.dump(content_dm_results))
      controller.send(:process_results, results)
    }

    context "content dm and regular results are present" do

      it "defines @reponse instance variable for the controller" do
        expect(controller.instance_variable_get(:@response)).not_to be_nil
      end

      it "adds content-dm totals to facet" do
        facet_fields = controller.instance_variable_get(:@response).facet_fields
        expect(facet_fields).to eq("format" => [ "digital_collections", "415" ])
      end
    end

    context "only cdm results present" do
      let(:results) { BentoSearch::ConcurrentSearcher.new(:cdm).search("foo").results }

      it "should still remove cdm results from bento results" do
        expect(results[:cdm]).to be_nil
      end
    end

    context "one or more concurrent searches fails" do

      it "should raise an error when a search has failed" do
        Object.const_set("BadService", Class.new {
                           include BentoSearch::SearchEngine
                           def search_implementation(args)
                             raise HTTPClient::TimeoutError.new
                           end
                         })

        BentoSearch.register_engine("bad_service") do |conf|
          conf.engine = "BadService"
        end

        results = BentoSearch::ConcurrentSearcher.new(:books_and_media, :cdm, :bad_service).search("foo").results
        expect { controller.send(:process_results, results) }.to raise_error(HTTPClient::TimeoutError)
      end
    end
  end

  def content_dm_results
    { "results" => { "pager" => { "total" => "415" } } }
  end
end
