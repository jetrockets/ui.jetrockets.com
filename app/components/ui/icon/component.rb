class Ui::Icon::Component < ApplicationComponent
  def initialize(path:, **options)
    @path = path
    @options = options
  end

  def call
    with_asset_finder(InlineSvg::ViteAssetFinder) do
      render_inline_svg(@path, @options)
    end
  end
end
