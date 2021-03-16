# frozen_string_literal: true

module Blacklight::PrimoCentral
  class SearchBuilder < Blacklight::SearchBuilder
    include Blacklight::PrimoCentral::SearchBuilderBehavior
    include Blacklight::PrimoCentral::SolrAdaptor

    self.default_processor_chain = [
      :add_query_to_primo_central,
      :skip_search?,
      :set_query_field,
      :process_advanced_search,
      :previous_and_next_document,
      :add_query_facets,
      :process_date_range_query,
    ]

    def skip_search?(params)
      # Skip useless searches
      params[:skip_search?] =  [ "q", "q_1", "q_2", "q_3"].all? do |key|
        next true if blacklight_params[key].nil?
        ["*", "", nil].include?(blacklight_params[key])
      end
    end
  end
end
