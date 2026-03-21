class Ui::Breadcrumbs::Component < ApplicationComponent
  DEFAULT_SEPARATOR = "/"

  def initialize(separator: DEFAULT_SEPARATOR, display_single_fragment: true, **options)
    @separator = separator
    @display_single_fragment = display_single_fragment
    @options = options
  end

  def call
    helpers.breadcrumbs(
      separator: separator_content,
      class: classes,
      display_single_fragment: @display_single_fragment,
      **@options.except(:class)
    )
  end

  private

  def separator_content
    content_tag(:span, @separator, class: "breadcrumbs__separator")
  end

  def classes
    class_names("breadcrumbs", @options[:class])
  end
end
