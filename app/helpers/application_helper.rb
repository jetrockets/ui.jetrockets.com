module ApplicationHelper
  def vite_asset_url_with_host(source)
    URI.join(root_url, vite_asset_url(source))
  end
end
