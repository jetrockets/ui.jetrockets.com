class Ui::Table::Component < ApplicationComponent
  SIZES = %i[xs sm md lg]
  DEFAULT_SIZE = :md

  def initialize(bordered: false, full: true, size: DEFAULT_SIZE, hovered: false, **options)
    @bordered = bordered
    @full = full
    @size = size
    @hovered = hovered
    @options = options
  end

  erb_template <<~ERB
    <div class="scroller scroller-x">
      <table class="<%= classes %>">
        <%= content %>
      </table>
    </div>
  ERB

  private

  def classes
    class_names(
      "table",
      @options.delete(:class),
      "table-bordered": @bordered,
      "table-full": @full,
      "table-hovered": @hovered,
      "table-#{@size}": @size.present?
    )
  end
end
