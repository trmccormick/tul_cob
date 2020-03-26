# frozen_string_literal: true

class PrimoAvailability
  include ActiveModel::Model

  class HTTPGetError < StandardError
  end

  attr_accessor :base_url
  validates :base_url, presence: true
  validates_format_of :base_url, with: /\Ahttps?:\/\/temple\..*\.exlibrisgroup\.com/

  def initialize(attributes = {})
    super
    validate!
  end

  def get_html_or_raise_error
    timeout = Rails.configuration.bento.dig(:primo, :timeout) || 10
    begin
      response = HTTParty.get(url, timeout: timeout)
  rescue Timeout::Error => e
    error = e
    end
    if response&.success?
      return response.body
    else
      message = (error) ? error.message : response.inspect
      raise HTTPGetError.new(message)
    end
  end

  def url
    @url ||= url_transforms
  end

  def url_transforms
    # ensure the new UI parameter is included
    (base_url.include? "&is_new_ui=true") ? base_url : "#{base_url}&is_new_ui=true"
  end
  end
