class Ui::Alert::Component < ApplicationComponent
  TYPES = %i[info error success warning default]
  DEFAULT_TYPE = :default

  def initialize(title:, icon_path: nil, type: DEFAULT_TYPE, **options)
    @type = TYPES.include?(type) ? type : DEFAULT_TYPE
    @title = title
    @icon_path = icon_path
    @options = options
  end

  private

  attr_reader :title, :options

  def classes
    class_names(
      "flex p-4 rounded-lg border",
      @options.delete(:class),
      "text-blue-900 bg-blue-50 border-blue-200": @type == :info,
      "text-red-900 bg-red-50 border-red-200": @type == :error,
      "text-green-900 bg-green-50 border-green-200": @type == :success,
      "text-yellow-900 bg-yellow-50 border-yellow-200": @type == :warning,
      "text-gray-900 bg-gray-50 bg-gray-50": @type == :default
    )
  end

  def icon
    if @icon_path
      helpers.vite_svg_tag @icon_path, class: "mt-0.5 shrink-0 w-4 h-4 mr-2"
    end
  end
end
