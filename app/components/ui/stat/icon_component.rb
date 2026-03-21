class Ui::Stat::IconComponent < ApplicationComponent
  def initialize(name = nil, **options)
    @name = name
    @options = options
  end

  def call
    content_tag :div, class: classes, **@options do
      helpers.ui.icon(@name || content, size: 6)
    end
  end

  private

  def classes
    class_names(
      "flex items-center justify-center size-12 mb-3 bg-gray-100 rounded-lg",
      @options.delete(:class)
    )
  end
end
