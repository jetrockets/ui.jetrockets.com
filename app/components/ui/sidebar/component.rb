class Ui::Sidebar::Component < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:nav, content, class: classes, **data_attributes, **@options.except(:class, :data))
  end

  private

  def classes
    class_names(
      "sidebar",
      @options[:class]
    )
  end

  def data_attributes
    default_data = { sidebar_target: "menu" }
    custom_data = @options[:data] || {}
    { data: default_data.merge(custom_data) }
  end
end
