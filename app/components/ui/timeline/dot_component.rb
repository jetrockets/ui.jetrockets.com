class Ui::Timeline::DotComponent < ApplicationComponent
  VARIANTS = %i[default info error success warning]
  DEFAULT_VARIANT = :default

  def initialize(variant: DEFAULT_VARIANT, icon: nil, **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_VARIANT
    @icon = icon
    @options = options
  end

  erb_template <<~ERB
    <div class="<%= classes %>">
      <% if @icon %>
        <%= helpers.ui.icon(@icon, size: 4) %>
      <% end %>
    </div>
  ERB

  private

  def classes
    class_names(
      "timeline-dot",
      "timeline-dot-#{@variant}",
      @options.delete(:class),
      "timeline-dot-icon": @icon
    )
  end
end
