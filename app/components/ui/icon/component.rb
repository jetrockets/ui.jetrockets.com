class Ui::Icon::Component < ApplicationComponent
  def initialize(icon_path:, **options)
    @icon_path = icon_path
    @options = options
  end

  def call
    with_asset_finder(InlineSvg::ViteAssetFinder) do
      render_inline_svg(@icon_path, @options)
    end
  end
end
