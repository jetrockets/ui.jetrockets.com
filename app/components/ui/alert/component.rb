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
      "flex p-4 text-sm rounded-lg",
      @options.delete(:class),
      "text-blue-800 bg-blue-50 bg-blue-50": @type == :info,
      "text-red-800 bg-red-50 bg-red-50": @type == :error,
      "text-green-800 bg-green-50 bg-green-50": @type == :success,
      "text-yellow-800 bg-yellow-50 bg-yellow-50": @type == :warning,
      "text-gray-800 bg-gray-50 bg-gray-50": @type == :default
    )
  end

  def icon
    if @icon_path
      helpers.vite_svg_tag @icon_path, class: "mt-0.5 shrink-0 w-4 h-4 mr-2"
    end
  end
end
