class Ui::Form::Toggle::Component < ApplicationComponent
  def initialize(label: nil, checked: false, hint: {}, **options)
    @label = label
    @checked = checked
    @hint = hint
    @options = options
  end

  erb_template <<~ERB
    <div class="form__group">
      <label class="flex items-center gap-2">
        <input type="checkbox" class="peer sr-only" <%= "checked" if @checked %> />
        <span class="form__toggle"></span>
        <span class="form__label"><%= @label %></span>
      </label>
      <span class="form__hint"><%= @checked ? @hint[:on] : @hint[:off] %></span>
    </div>
  ERB
end