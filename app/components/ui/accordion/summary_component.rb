class Ui::Accordion::SummaryComponent < ApplicationComponent
  def initialize(icon: "chevron-down", **options)
    @icon = icon
    @options = options
  end

  erb_template <<~ERB
    <summary class="<%= classes %>">
      <%= content %>
      <%= helpers.ui.icon(@icon, class: icon_classes) if @icon %>
    </summary>
  ERB

  private

  def classes
    class_names(
      "flex items-center justify-between gap-3 py-3.5 font-medium cursor-pointer",
      @options.delete(:class)
    )
  end

  def icon_classes
    "transition-transform size-4 group-open:-rotate-180"
  end
end
