# frozen_string_literal: true

module SearchHelper
  ##
  # Links More bento block facet back to catalog or content DM link.
  # @param [Blacklight::Solr::Response::Facets::FacetField] facet_field
  # @param [String] item
  # @return [String]
  def path_for_books_and_media_facet(facet_field, item)
    if item.value == "digital_collections"
      if params[:q].blank?
        "https://digital.library.temple.edu/digital/search"
      else
        query = "#{params[:q]}".gsub("/", " ")
        "https://digital.library.temple.edu/digital/search/searchterm/#{query}/order/nosort"
      end
    else
      search_catalog_url(search_state.add_facet_params_and_redirect(facet_field, item))
    end
  end

  def renderable_results(results = @results, options = {})
    results.select { |engine_id, result| render_search?(result, options) }
  end

  def render_search?(result, options = {})
    id = result.engine_id
    !(["more", "resource_types"].include?(id) &&
       total_items(result) == 0) &&
    !(is_child_box?(id) && !options[:render_child_box])
  end

  def bento_titleize(id)
    engine = BentoSearch.get_engine(id)
    if id == "books_and_media"
      link_to "Books & Media", engine.url(self), id: "bento_" + id + "_header"
    else
      link_to id.titleize , engine.url(self), id: "bento_" + id + "_header"
    end
  end

  def render_bento_results(results = @results, options = {})
    results_class = options[:results_class] || "d-md-flex flex-wrap"
    comp_class = options[:comp_class] || "bento_compartment p-2 mt-4 mr-4"

    render partial: "bento_results", locals: {
      results_class: results_class,
      comp_class: comp_class,
      results: results, options: options }
  end

  def render_linked_results(engine_id)
    engine_ids = engine_display_configurations[engine_id][:linked_engines] || [] rescue []
    results = @results.select { |id, result| engine_ids.include? id }
    render_bento_results(results, render_child_box: true, results_class: "bento_results", comp_class: "bento_compartment")
  end

  def is_child_box?(id)
    linked_engines.include? id
  end

  def linked_engines
    engine_display_configurations.select { |id, config| config[:linked_engines] }
      .map { |id, config| config[:linked_engines] }
      .flatten
  end

  def engine_display_configurations
    @engine_configurations ||= @results.map   { |engine_id, result|
      config = BentoSearch.get_engine(engine_id).configuration[:for_display]
      [engine_id, config]
    }.to_h
  end
end
