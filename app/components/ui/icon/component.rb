class Ui::Icon::Component < ApplicationComponent
  SIZES = %i[4 6 8]
  DEFAULT_SIZE = 4

  def initialize(icon_path:, size: DEFAULT_SIZE, **options)
    @icon_path = icon_path
    @size = size
    @options = options
  end

  def call
    with_asset_finder(InlineSvg::ViteAssetFinder) do
      render_inline_svg(@icon_path, icon_classes)
    end
  end

  def icon_classes
    {
      class: class_names(
        "h-#{@size} w-#{@size}",
        @options.delete(:class)
      ),
      **@options
    }
  end
end
