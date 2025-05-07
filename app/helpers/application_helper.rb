module ApplicationHelper
  include Pagy::Frontend
  ActionView::Base.default_form_builder = FormBuilders::DefaultFormBuilder

  def set_body_class(classes)
    @body_class = classes
  end

  def body_classes
    class_names("body__main", @body_class)
  end

  def vite_asset_url_with_host(source)
    URI.join(root_url, vite_asset_url(source))
  end

  def vite_svg_tag(filename, transform_params = {})
    with_asset_finder(InlineSvg::ViteAssetFinder) do
      render_inline_svg(filename, transform_params)
    end
  end

  def close_btn(id = nil)
    is_turbo = respond_to?(:turbo_frame_request?) && turbo_frame_request?

    attributes = {
      type: "button",
      class: "drawer__close"
    }

    if is_turbo
      attributes["data-action"] = "click->drawer-turbo#close"
    else
      attributes["data-action"] = "click->drawer#close"
      attributes["aria-label"] = "Close"
      attributes["data-id"] = id if id.present?
    end

    tag.button(**attributes) do
      vite_svg_tag "images/icons/close.svg"
    end
  end
end
