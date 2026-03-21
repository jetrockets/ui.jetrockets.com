class Ui::Sidebar::SectionComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag(:div, content, class: classes, **@options.except(:class))
  end

  private

  def classes
    class_names(
      "sidebar__section",
      @options[:class]
    )
  end
end
