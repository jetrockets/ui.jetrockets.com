class Ui::Badge::Component < ApplicationComponent
  TYPES = %i[default blue red green yellow indigo purple pink]
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
      @options.delete(:class),
      "bg-gray-100 text-gray-800": @type == :default,
      "bg-blue-100 text-blue-800": @type == :blue,
      "bg-red-100 text-red-800": @type == :red,
      "bg-green-100 text-green-800": @type == :green,
      "bg-yellow-100 text-yellow-800": @type == :yellow,
      "bg-indigo-100 text-indigo-800": @type == :indigo,
      "bg-purple-100 text-purple-800": @type == :purple,
      "bg-pink-100 text-pink-800": @type == :pink
    )
  end
end
