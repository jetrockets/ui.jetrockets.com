class Ui::Alert::Component < ApplicationComponent
  TYPES = %i[info error success warning default]
  DEFAULT_TYPE = :default

  def initialize(type: DEFAULT_TYPE, title:, **options)
    @type = TYPES.include?(type) ? type : DEFAULT_TYPE
    @title = title
    @options = options
  end

  def call
    content_tag :div, content, class: classes, role: "alert", **@options do
      concat(title_tag) 
      concat(content)
    end
  end

  def title_tag
    content_tag :h3, @title, class: "font-bold"
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
