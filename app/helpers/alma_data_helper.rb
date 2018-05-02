# frozen_string_literal: true

module AlmaDataHelper
  include Blacklight::CatalogHelperBehavior

  def availability_status(item)
    non_circulating = item.dig("item_data", "policy", "desc")
    base_status = item["item_data"]["base_status"]["value"]
    if base_status == "1"
      if non_circulating.nil?
        content_tag(:span, "", class: "check") + "Available"
      elsif non_circulating.include?("Non-circulating")
        content_tag(:span, "", class: "check") + "Library Use Only"
      else
        content_tag(:span, "", class: "check") + "Available"
      end
    elsif base_status == "0"
      unavailable_items(item)
    end
  end

  def unavailable_items(item)
    if item["item_data"]["process_type"].present?
      process_type = Rails.configuration.process_types[item["item_data"]["process_type"]["value"]]
      content_tag(:span, "", class: "close-icon") + process_type
    else
      content_tag(:span, "", class: "close-icon") + "Checked out or currently unavailable"
    end
  end

  def description(item)
    if item["item_data"]["description"].present?
      return "Description: " + item["item_data"]["description"]
    end
  end

  def public_note(item)
    if item["item_data"]["public_note"].present?
      return "Note: " + item["item_data"]["public_note"]
    end
  end

  def location_status(item)
    if item["holding_data"]["in_temp_location"] == true
      temp_library = item["holding_data"]["temp_library"]["value"]
      temp_location = item["holding_data"]["temp_location"]["value"]
      "#{Rails.configuration.locations[temp_library][temp_location]}"
    else
      library = item["item_data"]["library"]["value"]
      location = item["item_data"]["location"]["value"]
      "#{Rails.configuration.locations[library][location]}"
    end
  end

  def missing_or_lost?(item)
    item["item_data"]["process_type"].has_value?("MISSING") || item["item_data"]["process_type"].has_value?("LOST_LOAN")
  end

  def group_and_order_items(items)
    showable_items = items.select { |item| item unless missing_or_lost?(item) }
    grouped_items = showable_items.group_by do |lib|
      (lib["holding_data"]["temp_library"]["value"] if lib["holding_data"]["in_temp_location"] == true) || (lib["item_data"]["library"]["value"])
    end
    sort_order_for_holdings(grouped_items)
  end

  def library_name_from_short_code(short_code)
    Rails.configuration.libraries[short_code]
  end

  def location_name_from_short_code(item)
    if item["holding_data"]["in_temp_location"] == true
      temp_library = item["holding_data"]["temp_library"]["value"]
      temp_location = item["holding_data"]["temp_location"]["value"]
      Rails.configuration.locations[temp_library][temp_location]
    else
      library = item["item_data"]["library"]["value"]
      location = item["item_data"]["location"]["value"]
      Rails.configuration.locations[library][location]
    end
  end

  def call_number(item)
    if item["holding_data"]["temp_call_number"].empty?
      item["holding_data"]["call_number"]
    else
      item["holding_data"]["temp_call_number"]
    end
  end

  def alternative_call_number(item)
    if item["item_data"]["alternative_call_number"].present?
      "(Also found under #{item["item_data"]["alternative_call_number"]})"
    end
  end

  def call_number_for_sort(item)
    if item["item_data"]["alternative_call_number"].present?
      item["item_data"]["alternative_call_number"]
    else
      item["holding_data"]["call_number"]
    end
  end

  def sort_order_for_holdings(items)
    sorted_library_hash = {}
    sorted_library_hash.merge!("MAIN" => items.delete("MAIN")) if items.has_key?("MAIN")
    items_hash = items.sort_by { |k, v| library_name_from_short_code(k) }.to_h
    sorted_library_hash = sorted_library_hash.merge!(items_hash)
    sorted_library_hash.each do |lib, items|
      unless items.empty?
        items.sort_by! { |item| [location_name_from_short_code(item), call_number_for_sort(item), item["item_data"]["description"]] }
      end
    end
    sorted_library_hash
  end
end
