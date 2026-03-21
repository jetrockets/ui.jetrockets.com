class Ui::Stepper::StepComponent < ApplicationComponent
  STATUSES = %i[pending current completed].freeze
  DEFAULT_STATUS = :pending

  def initialize(text = nil, status: DEFAULT_STATUS, number: nil, icon: nil, description: nil, url: nil, **options)
    @text = text
    @status = STATUSES.include?(status) ? status : DEFAULT_STATUS
    @number = number
    @icon = icon
    @description = description
    @url = url
    @options = options
  end

  erb_template <<~ERB
    <li class="<%= item_classes %>">
      <% if @url && @status != :pending %>
        <a href="<%= @url %>" class="stepper__link">
          <%= render_indicator %>
          <%= render_content %>
        </a>
      <% else %>
        <%= render_indicator %>
        <%= render_content %>
      <% end %>
    </li>
  ERB

  private

  def render_indicator
    content_tag(:div, class: "stepper__indicator") do
      if @status == :completed && !@icon
        helpers.ui.icon("check", class: "stepper__icon")
      elsif @icon
        helpers.ui.icon(@icon, class: "stepper__icon")
      elsif @number
        content_tag(:span, @number, class: "stepper__number")
      else
        content_tag(:span, nil, class: "stepper__dot")
      end
    end
  end

  def render_content
    content_tag(:div, class: "stepper__content") do
      safe_join([
        content_tag(:span, @text || content, class: "stepper__title"),
        @description ? content_tag(:span, @description, class: "stepper__description") : nil
      ].compact)
    end
  end

  def item_classes
    class_names(
      "stepper__item",
      "stepper__item-#{@status}",
      @options.delete(:class),
      "stepper__item-has-url" => @url.present?
    )
  end
end
