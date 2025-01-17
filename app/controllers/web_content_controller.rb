# frozen_string_literal: true

class WebContentController < CatalogController
  include CatalogConfigReinit

  configure_blacklight do |config|
    # Remove show and index doc actions.
    config.index.document_actions = Blacklight::NestedOpenStructWithHashAccess.new({})

    config.document_model = SolrWebContentDocument
    config.connection_config = config.connection_config.dup
    config.connection_config[:url] = config.connection_config[:web_content_url]
    config.track_search_session = false
    config.index.title_field = "web_title_display"
    # Do not inherit default solr configs from the catalog.
    config.default_solr_params = {}

    # Facet fields
    config.add_facet_field "web_content_type_facet",
      label: "Library Website",
      limit: true,
      collapse: false,
      helper_method: :format_types,
      component: true

    # Index fields
    config.add_index_field "web_content_type_t", label: "Content Type", helper_method: :capitalize_type
    config.add_index_field "web_job_title_display", label: "Job Title"
    config.add_index_field "web_base_url_display", label: "Link"
    config.add_index_field "web_description_display", label: "Description"
    config.add_index_field "web_email_address_display", label: "Email Address"
    config.add_index_field "web_phone_number_display", label: "Phone Number", helper_method: :format_phone_number
    config.add_index_field "web_specialties_display", label: "Specialties", helper_method: :website_list
    config.add_index_field "web_subject_display", label: "Subjects", helper_method: :website_list
    config.add_index_field "web_blurb_display", label: "Blurb"
    config.add_index_field "web_tags_display", label: "Tags"
    config.add_index_field "web_link_display", label: "Link"

    # Search fields
    config.add_search_field "all_fields", label: "All Fields"

    config.add_search_field("title") do |field|
      field.solr_parameters = {
        qf: "${title_qf}",
        pf: "${title_pf}",
      }

      field.solr_adv_parameters = {
        # Added to avoid solr errors when users switch between searches
        qf: "$title_qf",
        pf: "$title_pf"
      }
    end

    # Sort fields.
    config.add_sort_field "score desc, title_sort asc", label: "relevance"
    config.add_sort_field "title_sort asc", label: "title (A to Z)"
    config.add_sort_field "title_sort desc", label: "title (Z to A)"
  end
end
