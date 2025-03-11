class Ui::Form::Checkbox::Component < ApplicationComponent
  def initialize(label: nil, checked: false, **options)
    @label = label
    @checked = checked
    @options = options
  end

  erb_template <<~ERB
    <label class="flex items-center gap-2">
      <input type="checkbox" class="<%= classes %>" <%= "checked" if @checked %> />
      <span class="form__label form__label-checkbox"><%= @label %></span>
    </label>
  ERB

  private

  def classes
    class_names(
      "form__checkbox",
      @options.delete(:class)
    )
  end
end