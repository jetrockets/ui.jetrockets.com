class Ui::Stepper::Component < ApplicationComponent
  def initialize(**options)
    @options = options
  end

  erb_template <<~ERB
    <nav class="<%= classes %>" aria-label="Progress">
      <ol class="stepper__list">
        <%= content %>
      </ol>
    </nav>
  ERB

  private

  def classes
    class_names(
      "stepper",
      @options.delete(:class)
    )
  end
end
