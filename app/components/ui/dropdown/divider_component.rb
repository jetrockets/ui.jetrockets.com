class Ui::Dropdown::DividerComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  def call
    content_tag :li, nil, class: classes, **@options
  end

  private

  def classes
    class_names("dropdown__divider", @options.delete(:class))
  end
end
