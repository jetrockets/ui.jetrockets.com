class Ui::Tabs::Component < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  erb_template <<~ERB
    <div class="tabs">
      <ul class="<%= classes %>">
        <%= content %>
      </ul>
    </div>
  ERB

  private

  def classes
    class_names(
      "tabs__list",
      @options.delete(:class)
    )
  end
end
