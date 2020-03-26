# frozen_string_literal: true

class PrimoAvailabilityController < ApplicationController

    layout proc { |controller| false if request.xhr? }

    def show
        pa = PrimoAvailability.new(base_url: params[:availability_url])
        availability_html = pa.get_html_or_raise_error
        render html: availability_html.html_safe
    end
end
  