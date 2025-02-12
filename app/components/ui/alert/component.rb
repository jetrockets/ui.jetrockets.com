class Ui::Alert::Component < ApplicationComponent
  TYPES = %i[info error success warning default]
  DEFAULT_TYPE = :default

  def initialize(title:, icon_path: nil, type: DEFAULT_TYPE, **options)
    @type = TYPES.include?(type) ? type : DEFAULT_TYPE
    @title = title
    @icon_path = icon_path
    @options = options
  end

  def call
    content_tag :div, class: classes, role: "alert", **@options do
      if @icon_path
        concat(content_tag(:div, helpers.inline_svg_vite_tag(@icon_path)))
      end
      concat(content_tag(:strong, @title))
      concat(content)
    end
  end

  def classes
    class_names(
      "p-4 text-sm rounded-lg",
      @options.delete(:class),
      "text-blue-800 bg-blue-50 bg-blue-50": @type == :info,
      "text-red-800 bg-red-50 bg-red-50": @type == :error,
      "text-green-800 bg-green-50 bg-green-50": @type == :success,
      "text-yellow-800 bg-yellow-50 bg-yellow-50": @type == :warning,
      "text-gray-800 bg-gray-50 bg-gray-50": @type == :default
    )
  end
end
