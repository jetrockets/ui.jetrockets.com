module ApplicationHelper
  include Pagy::Frontend
  ActionView::Base.default_form_builder = FormBuilders::DefaultFormBuilder

  def set_body_class(classes)
    @body_class = classes
  end

  def body_classes
    class_names("body", @body_class)
  end

  def vite_asset_url_with_host(source)
    URI.join(root_url, vite_asset_url(source))
  end

  def vite_svg_tag(filename, transform_params = {})
    with_asset_finder(InlineSvg::ViteAssetFinder) do
      render_inline_svg(filename, transform_params)
    end
  end

  def vite_icon_tag(filename, transform_params = {})
    with_asset_finder(InlineSvg::ViteAssetFinder) do
      render_inline_svg("images/icons/#{filename}", transform_params)
    end
  end

  def render_code_example(partial_path)
    partial_file_path = Rails.root.join("app/views/#{partial_path}.html.erb")

    if File.exist?(partial_file_path)
      raw_content = File.read(partial_file_path)
      content_tag(:pre, content_tag(:code, html_escape(raw_content)))
    else
      "Partial not found: #{partial_path}"
    end
  end
end
