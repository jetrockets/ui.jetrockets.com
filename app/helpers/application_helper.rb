module ApplicationHelper
  ActionView::Base.default_form_builder = FormBuilders::DefaultFormBuilder

  def component(name, *args, **kwargs, &block)
    component = name.to_s.camelize.constantize::Component
    render(component.new(*args, **kwargs), &block)
  end

  def vite_asset_url_with_host(source)
    URI.join(root_url, vite_asset_url(source))
  end

  def inline_svg_vite_tag(filename, transform_params = {})
    with_asset_finder(InlineSvg::ViteAssetFinder) do
      render_inline_svg(filename, transform_params)
    end
  end
end
