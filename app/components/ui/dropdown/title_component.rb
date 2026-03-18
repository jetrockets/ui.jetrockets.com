class Ui::Dropdown::TitleComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :h6, content, class: classes, **@options
  end

  private

  def classes
    class_names("dropdown__title", @options.delete(:class))
  end
end
