class Ui::Badge::Component < ApplicationComponent
  TYPES = %i[default blue red green yellow indigo purple pink ]
  DEFAULT_TYPE = :default

  def initialize(type: DEFAULT_TYPE, title:, **options)
    @type = TYPES.include?(type) ? type : DEFAULT_TYPE
    @title = title
    @options = options
  end

  def call
    content_tag :span, @title, class: classes, **@options
  end

  def classes
    class_names(
      "text-sm font-medium px-2.5 py-0.5 rounded",
      "bg-#{@type}-100 text-#{@type}-800": @type != :default,
      "bg-gray-100 text-gray-800": @type == :default
    )
  end
end
