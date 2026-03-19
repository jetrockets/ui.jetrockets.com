class Ui::Dropdown::MenuComponent < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  erb_template <<~ERB
    <div class="dropdown__menu" data-dropdown-target="menu">
      <ul class="<%= classes %>">
        <%= content %>
      </ul>
    </div>
  ERB

  private

  def classes
    class_names(
      "dropdown__wrapper",
      @options.delete(:class)
    )
  end
end
