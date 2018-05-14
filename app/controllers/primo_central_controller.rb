# frozen_string_literal: true

class PrimoCentralController < CatalogController
  include Blacklight::Catalog
  include CatalogConfigReinit

  helper_method :browse_creator

  configure_blacklight do |config|
    # Class for sending and receiving requests from a search index
    config.repository_class = Blacklight::PrimoCentral::Repository

    # Class for converting Blacklight's url parameters to into request parameters for the search index
    config.search_builder_class = Blacklight::PrimoCentral::SearchBuilder

    # Model that describes a Document
    config.document_model = ::PrimoCentralDocument

    # Model that maps search index responses to the blacklight response model
    config.response_model = Blacklight::PrimoCentral::Response

    config.index.document_presenter_class = PrimoCentralPresenter

    # Pagination handler
    config.facet_paginator_class = Blacklight::PrimoCentral::FacetPaginator

    # Search fields
    config.add_search_field :any, label: "All Fields"
    config.add_search_field :title
    config.add_search_field :creator, label: "Author/Creator"
    config.add_search_field :subject
    config.add_search_field :isbn, label: "ISBN"
    config.add_search_field :issn, label: "ISSN"

    # Index fields
    config.add_index_field :isPartOf, label: "Is Part Of"
    config.add_index_field :creator, label: "Author/Creator", multi: true
    config.add_index_field :type, label: "Resource Type", raw: true, helper_method: :index_translate_resource_type_code
    config.add_index_field :date, label: "Year"

    # Facet fields
    config.add_facet_field :tlevel, label: "Availability", home: true, helper_method: :translate_availability_code
    config.add_facet_field :rtype, label: "Resource Type", limit: true, show: true, home: true, helper_method: :translate_resource_type_code
    config.add_facet_field :creator, label: "Author/Creator"
    config.add_facet_field :topic, label: "Topic"
    config.add_facet_field :lang, label: "Language", limit: true, show: true, helper_method: :translate_language_code

    # Show fields
    config.add_show_field :creator, label: "Author/Creator", helper_method: :browse_creator, multi: true
    config.add_show_field :contributor, label: "Contributor", helper_method: :browse_creator, multi: true
    config.add_show_field :type, label: "Resource Type", helper_method: :doc_translate_resource_type_code
    config.add_show_field :publisher, label: "Published"
    config.add_show_field :date, label: "Date"
    config.add_show_field :isPartOf, label: "Is Part of"
    config.add_show_field :relation, label: "Related Title", helper_method: "list_with_links"
    config.add_show_field :description, label: "Note"
    config.add_show_field :subject, helper_method: :list_with_links, multi: true
    config.add_show_field :isbn, label: "ISBN"
    config.add_show_field :issn, label: "ISSN"
    config.add_show_field :lccn, label: "LCCN"
    config.add_show_field :doi, label: "DOI"
    config.add_show_field :languageId, label: "Language", multi: true, helper_method: :doc_translate_language_code
  end

  # get a single document from the index
  # to add responses for formats other than html or json see _Blacklight::Document::Export_
  def show
    @document = repository.find params[:id]
    respond_to do |format|
      format.html { setup_next_and_previous_documents }
      format.json { render json: { response: { document: @document } } }
      additional_export_formats(@document, format)
    end
  end

  def render_sms_action?(_config, _options)
    # Render if the item can be found at a library
    false
  end

  def browse_creator(args)
    creator = args[:document][args[:field]] || []
    base_path = helpers.base_path
    creator.map do |name|
      query = view_context.send(:url_encode, (name))
      view_context.link_to(name, base_path + "?search_field=creator&q=#{query}")
    end
  end
end
