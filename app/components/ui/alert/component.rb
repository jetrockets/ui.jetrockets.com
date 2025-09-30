class Ui::Alert::Component < ApplicationComponent
  VARIANTS = %i[default info error success warning]
  DEFAULT_TYPE = :default

  def initialize(title:, icon: nil, variant: DEFAULT_TYPE, **options)
    @variant = VARIANTS.include?(variant) ? variant : DEFAULT_TYPE
    @title = title
    @icon = icon
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, class: classes, **@options do %>
      <%= icon %>

      <div class="flex flex-col gap-2 flex-1">
        <strong class="font-semibold">
          <%= @title %>
        </strong>

        <%= content %>
      </div>
    <% end %>
  ERB

  private

  def classes
    class_names(
      "flex p-4 rounded-lg border border-gray-200 text-sm",
      @options.delete(:class),
      "text-gray-900 bg-gray-50 bg-gray-50": @variant == :default,
      "text-blue-900 bg-blue-50 border-blue-200": @variant == :info,
      "text-red-900 bg-red-50 border-red-200": @variant == :error,
      "text-green-900 bg-green-50 border-green-200": @variant == :success,
      "text-yellow-900 bg-yellow-50 border-yellow-200": @variant == :warning
    )
  end

  def icon
    if @icon
      helpers.vite_icon_tag @icon, class: "mt-0.5 shrink-0 size-4 mr-2"
    end
  end
end
