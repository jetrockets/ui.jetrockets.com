module ApplicationHelper
  include Pagy::Frontend
  ActionView::Base.default_form_builder = FormBuilders::DefaultFormBuilder

  def set_body_class(classes)
    @body_class = classes
  end

  def body_classes
    class_names("body", @body_class)
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

  # Picture tag
  def vite_asset_exists?(logical_path)
    File.exist?(Rails.root.join("app/assets", logical_path))
  end

  def vite_asset_url_with_host(source)
    URI.join(root_url, vite_asset_url(source))
  end

  def source_tag(src)
    tag.source(type: "image/avif", srcset: vite_asset_path(src))
  end

  # Use it in views like this: <%= picture_tag("images/example.jpg", alt: "Example Image") %>
  def picture_tag(src, options = {})
    avif_path = src.gsub(/\.(png|jpg|jpeg)$/, ".avif")

    return unless vite_asset_exists?(src)

    return vite_image_tag(src, **options) unless vite_asset_exists?(avif_path)

    tag.picture do
      source_tag(avif_path) + vite_image_tag(src, **options)
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
