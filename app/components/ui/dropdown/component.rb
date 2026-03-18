class Ui::Dropdown::Component < ApplicationComponent
  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, classes: classes, **attrs do %>
      <%= content %>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "dropdown" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end

  def classes
    class_names(
      "dropdown",
      @options.delete(:class)
    )
  end
end
