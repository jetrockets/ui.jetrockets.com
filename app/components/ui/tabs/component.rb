class Ui::Tabs::Component < ApplicationComponent
  VARIANTS = %i[pill underline].freeze
  DEFAULT_VARIANT = :pill

  def initialize(variant: DEFAULT_VARIANT, **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @options = options
  end

  erb_template <<~ERB
    <div class="<%= wrapper_classes %>">
      <ul class="<%= classes %>">
        <%= content %>
      </ul>
    </div>
  ERB

  private

  def wrapper_classes
    class_names(
      "tabs",
      "scroller scroller-x w-full",
      { "tabs-underline": @variant == :underline }
    )
  end

  def classes
    class_names(
      "tabs__list",
      @options.delete(:class)
    )
  end
end
