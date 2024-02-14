module ApplicationHelper
  def vite_asset_url_with_host(source)
    URI.join(root_url, vite_asset_url(source))
  end

  def inline_svg_vite_tag(filename, transform_params = {})
    with_asset_finder(InlineSvg::ViteAssetFinder) do
      render_inline_svg(filename, transform_params)
    end
  end
end
