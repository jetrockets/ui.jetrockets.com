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
end
