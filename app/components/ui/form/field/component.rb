class Ui::Form::Field::Component < ApplicationComponent
  renders_one :input, Ui::Form::Input::Component
  renders_many :checkboxes, Ui::Form::Checkbox::Component
  renders_many :radios, Ui::Form::Radio::Component
  renders_one :toggle, Ui::Form::Toggle::Component

  def initialize(label: nil, help: nil, **options)
    @label = label
    @help = help
    @options = options
  end

  erb_template <<~ERB
    <div class="form__group">
      <label class="form__label">
        <%= @label %>
      </label>
      <div class="flex flex-col gap-2">
        <% radios.each do |radio| %>
          <%= radio %>
        <% end %>
      </div>
      <%= input %>
      <% checkboxes.each do |checkbox| %>
        <%= checkbox %>
      <% end %>
      <%= toggle %>
      <p class="form__help"><%= @help %></p>
    </div>
  ERB
end