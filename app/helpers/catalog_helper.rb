# frozen_string_literal: true

module CatalogHelper
  include Blacklight::CatalogHelperBehavior
  include BlacklightAlma::CatalogOverride

  def thumbnail_classes(document)
    classes = %w[thumbnail col-sm-3 col-lg-2]
    document.fetch(:format, []).compact.each do |format|
      classes << "#{format.parameterize.downcase.underscore}_format"
    end
    classes.join " "
  end

  def isbn_data_attribute(document)
    values = document.fetch(:isbn_display, [])
    values = [values].flatten.map { |value|
      value.gsub(/\D/, "") if value
    }.compact.join(",")

    "data-isbn=#{values}" if !values.empty?
  end

  def lccn_data_attribute(document)
    values = document.fetch(:lccn_display, [])
    values = [values].flatten.map { |value|
      value.gsub(/\D/, "") if value
    }.compact.join(",")

    "data-lccn=#{values}" if !values.empty?
  end

  def default_cover_image(document)
    formats = document.fetch(:format, [])
    # In case we fetched the default value, or the format value was ""
    formats << "unknown" if formats.empty?
    format = formats.first.to_s.parameterize.underscore
    image = Rails.application.config.assets.default_cover_image
      .merge(
        "article" => "journal_periodical",
        "dissertation" => "script",
        "dissertation_thesis" => "script",
        "government_document" => "journal_periodical",
        "journal" => "journal_periodical",
        "legal_document" => "journal_periodical",
        "newspaper_article" => "journal_periodical",
        "other" => "unknown",
        "patent" => "journal_periodical",
        "reference_entry" => "journal_periodical",
        "research_dataset" => "dataset",
        "review" => "journal_periodical",
        "statistical_data_set" => "dataset",
        "technical_report" => "journal_periodical",
        "book_chapter" => "book",
        "text_resource" => "journal_periodical",
    ).fetch(format, "unknown")

    "svg/" + image + ".svg"
  end

  def separate_formats(response)
    document = response[:document]
    formats = %w[]
    document[:format].each do |format|
      format = h(format)
      css_class = format.to_s.parameterize.underscore
      formats << "<span class='#{css_class}'> #{format}</span>"
    end
    formats.join("<span class='format-concatenator'>and</span>")
  end

  # Used to toggle the search bar form path.
  # Hack for Advanced search page
  def search_url_picker
    current_page?("/advanced") ? search_catalog_url : search_action_url
  end

  # Overridden because we want to use our merged @response["docs"] with docs
  # from solr and primo together.
  def current_bookmarks(response = nil)
    response ||= @response
    @current_bookmarks ||=
      current_or_guest_user
      .bookmarks_for_documents(@response["docs"] ||
    response.documents).to_a
  end

  ##
  # Overridden so that we can controll the number of pages from the controller.
  #
  # Look up the current per page value, or the default if none if set
  #
  # @return [Integer]
  def current_per_page
    (@response["rows"] if @response["rows"] && @response["rows"] > 0) ||
      (@response.rows if @response && @response.rows > 0) ||
      params.fetch(:per_page, default_per_page).to_i
  end

  def render_online_availability(doc_presenter)
    online_resources = [doc_presenter.field_value("electronic_resource_display")]
      .select { |r| !r.empty? }.compact

    if !online_resources.empty?
      render "online_availability", online_resources: online_resources
    end
  end

  def render_online_availability_button(doc)
    links = check_for_full_http_link(document: doc, field: "electronic_resource_display")

    if !links.empty?
      render "online_availability_button", document: doc, links: links
    end
  end

  ##
  # Overridden from module Blacklight::BlacklightHelperBehavior.
  #
  # Overridden in order to disable rel alternate links added to page headers.
  def render_link_rel_alternates(document = @document, options = {})
    ""
  end

  def advanced_catalog_search_path
    params = @search_state.to_h.select { |k, v| !["page"].include? k }
    blacklight_advanced_search_engine.advanced_search_path(params)
  end

  def render_availability(doc, doc_presenter)
    if doc.purchase_order? && !current_user
      link_to(t("blacklight.requests.log_in"), new_user_session_with_redirect_path(request.url),  data: { "ajax-modal": "trigger" })
    elsif doc.purchase_order?
      doc_presenter.purchase_order_button
    elsif index_fields(doc).fetch("availability", nil)
      render "index_availability_section", document: doc
    end
  end

  def render_email_form_field
    if !current_user&.email
      render partial: "email_form_field"
    end
  end

  def library_link
    Rails.configuration.library_link
  end

  def grouped_citations(documents)
    Citation.grouped_citations(documents.map(&:citations))
  end

  def render_marc_view
    if @document.respond_to?(:to_marc)
      render "marc_view"
    else
      t("blacklight.search.librarian_view.empty")
    end
  end

  def back_to_catalog_path
    search_catalog_path(search_params)
  end

  def back_to_books_path
    search_books_path(search_params)
  end

  def back_to_journals_path
    search_journals_path(search_params)
  end

  def back_to_articles_path
    search_path(search_params)
  end

  def render_electronic_notes(document)
    collection_id = document["electronic_collection_id"]
    service_id = document["electronic_service_id"]

    collection_notes = Rails.configuration.electronic_collection_notes[collection_id] || {}
    service_notes = Rails.configuration.electronic_service_notes[service_id] || {}

    if collection_notes.present? || service_notes.present?
      render partial: "electronic_notes", locals: { collection_notes: collection_notes, service_notes: service_notes }
    end
  end

  def get_search_params(field, query)
    case field
    when "title_uniform_display", "title_addl_display"
      { search_field: "title", q: query }
    when "relation"
      { search_field: "title", q: query["relatedTitle"] }
    else
      { search_field: field, q: query }
    end
  end

  def fielded_search(query, field)
    params = get_search_params(field, query)
    link_url = search_action_path(params)
    title = params[:title] || params[:q]
    link_to(title, link_url)
  end

  def list_with_links(args)
    args[:document][args[:field]].map { |field| content_tag(:li,  fielded_search(field, args[:field]), class: "list_items") }.join("").html_safe
  end

  def creator_index_separator(args)
    creator = args[:document][args[:field]]
    creator.map do |name|
      plain_text_subfields = name.gsub("|", " ")
      creator = plain_text_subfields
    end
    creator
  end

  def subject_links(args)
    args[:document][args[:field]].map do |subject|
      link_to(subject.sub("— — ", "— "), "#{search_catalog_path}?f[subject_facet][]=#{CGI.escape subject}")
    end
  end

  def has_one_electronic_resource?(document)
    document.fetch("electronic_resource_display", []).length == 1
  end

  def has_many_electronic_resources?(document)
    document.fetch("electronic_resource_display", []).length > 1
  end

  def check_holdings_library_name(document)
    document.fetch("holdings_with_no_items_display", []).map(&:split).to_h.keys
  end

  def check_holdings_call_number(document)
    document.fetch("call_number_display", []).first
  end

  def check_holdings_location(document, library)
    locations_array = []
    locations = document.fetch("holdings_with_no_items_display", []).select { |location| location.include?(library) }.map { |field| field.split() }
    locations.each { |k, v|
      shelf = Rails.configuration.locations.dig(k, v)
      locations_array << shelf
    }
    locations_array
  end

  def check_for_full_http_link(args)
    [args[:document][args[:field]]].flatten.compact.map { |field|
      if field.include?("http")
        electronic_access_links(field)
      else
        electronic_resource_link_builder(field)
      end
    }.join("").html_safe
  end

  def electronic_access_links(field)
    link_text = field.split("|").first.sub(/ *[ ,.\/;:] *\Z/, "")
    link_url = field.split("|").last
    new_link = content_tag(:td, link_to(link_text, link_url, title: "Target opens in new window", target: "_blank"), class: "electronic_links list_items")
    new_link
  end

  def holdings_summary_information(document)
    field = document.fetch("holdings_summary_display", [])
    unless field.empty?
      field.first.split("|").first
    end
  end

  def render_holdings_summary(document)
    if holdings_summary_information(document).present?
      content_tag(:td, "Description: " + holdings_summary_information(document), id: "holdings-summary")
    else
      content_tag(:td, "We are unable to find availability information for this record. Please contact the library for more information.", id: "error-message")
    end
  end

  def build_holdings_summary(items, document)
    holdings_summaries = document.fetch("holdings_summary_display", []).map { |summary|
      summary.split("|")
    }.map { |summary|
      [summary.last, summary.first]
    }.to_h

    new_summary = items.map { |item|
        library = item.first
        summaries = item.last.map { |v| v["holding_data"]["holding_id"] }
          .uniq.select { |id| holdings_summaries.keys.include?(id) }
          .map { |holding| holdings_summaries[holding] }
          .join(", ")

        [ library, summaries ]
      }.to_h
  end

  def electronic_resource_list_item(portfolio_pid, db_name, addl_info)
    item_parts = [render_alma_eresource_link(portfolio_pid, db_name), addl_info]
    item_html = item_parts.compact.join(" - ").html_safe
    content_tag(:td, item_html , class: " electronic_links list_items")
  end

  def electronic_resource_link_builder(field)
    return if field.empty?
    portfolio_pid, db_name, addl_info, availability = field.split("|")
    return if availability == "Not Available"
    db_name ||= "Find it online"
    addl_info = nil if addl_info&.empty?
    electronic_resource_list_item(portfolio_pid, db_name, addl_info)
  end

  def single_link_builder(field)
    if field.include?("http")
      field.split("|").last
    else
      electronic_resource_from_traject = field.split("|")
      portfolio_pid = electronic_resource_from_traject.first
      alma_electronic_resource_direct_link(portfolio_pid)
    end
  end
end
