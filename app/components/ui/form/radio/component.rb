class Ui::Form::Radio::Component < ApplicationComponent
  def initialize(label: nil, value: nil, checked: false, name: nil, **options)
    @label = label
    @value = value
    @checked = checked
    @name = name
    @options = options
  end

  erb_template <<~ERB
    <label class="flex items-center gap-2">
      <input type="radio" value="<%= @value %>" name="<%= @name %>" class="<%= classes %>" <%= "checked" if @checked %> />
      <span class="form__label form__label-radio"><%= @label %></span>
    </label>
  ERB

  private

  def classes
    class_names(
      "form__radio",
      @options.delete(:class)
    )
  end
end