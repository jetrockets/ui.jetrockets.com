class Ui::Breadcrumb::Component < ApplicationComponent
  include Gretel::ViewHelpers

  def initialize(crumb_key, crumb_object = nil, **options)
    @crumb_key = crumb_key
    @crumb_object = crumb_object
    @options = options
  end

  def call
    breadcrumb @crumb_key, @crumb_object if @crumb_key.present?
    breadcrumbs(separator: content_tag(:span, "/", class: "breadcrumbs__separator"), class: "breadcrumbs wrapper", display_single_fragment: true)
  end
end
