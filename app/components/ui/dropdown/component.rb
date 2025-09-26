class Ui::Dropdown::Component < ApplicationComponent
  renders_one :trigger, "TriggerComponent"
  renders_one :menu, "MenuComponent"

  def initialize(**options)
    super
    @options = options
  end

  erb_template <<~ERB
    <%= content_tag :div, **attrs do %>
      <%= trigger %>

      <div class="dropdown" data-dropdown-target="menu">
        <%= menu %>
      </div>
    <% end %>
  ERB

  private

  def attrs
    data_attributes = ({ controller: "dropdown" }).deep_merge(@options.fetch(:data, {}))
    @options.merge(data: data_attributes)
  end

  class TriggerComponent < ApplicationComponent
    def initialize(**options)
      @options = options
      @options[:data] ||= {}
      @options[:data][:dropdown_target] = "trigger"
    end

    def call
      content_tag :span, content, role: :button, class: classses, **@options
    end

    private

    def classses
      class_names(
        "dropdown__trigger",
        @options.delete(:class)
      )
    end
  end

  class MenuComponent < ApplicationComponent
    renders_one :title
    renders_many :elements, types: {
      link: "LinkComponent",
      button: "ButtonComponent",
      item: "ItemComponent",
      divider: "DividerComponent"
    }

    erb_template <<~ERB
      <%= title_content %>
      <ul class="<%= classes %>">
        <% elements.each do |element| %>
          <%= element %>
        <% end %>
      </ul>
    ERB

    private

    def title_content
      content_tag :h6, title, class: "dropdown__title" if title?
    end

    def classes
      class_names(
        "dropdown__wrapper",
        @options.delete(:class)
      )
    end

    class ItemComponent < ApplicationComponent
      def initialize(**options)
        @options = options
      end

      def call
        content_tag :li, content, class: classes, **@options
      end

      private

      def classes
        class_names(
          "dropdown__item",
          @options.delete(:class)
        )
      end
    end

    class LinkComponent < ApplicationComponent
      def initialize(title: nil, href: nil, **options)
        @title = title
        @href = href
        @options = options
      end

      erb_template <<~ERB
        <li class="dropdown__item">
          <%= link_to @title, @href, class: classes, **@options %>
        </li>
      ERB

      private

      def classes
        class_names(
          "dropdown__link",
          @options.delete(:class)
        )
      end
    end

    class ButtonComponent < ApplicationComponent
      def initialize(title: nil, href: nil, **options)
        @title = title
        @href = href
        @options = options
      end

      erb_template <<~ERB
        <li class="dropdown__item">
          <%= button_to @title, @href, **@options, class: classes, form: { class: "dropdown__form" } %>
        </li>
      ERB

      private

      def classes
        class_names(
          "dropdown__link",
          @options.delete(:class)
        )
      end
    end

    class DividerComponent < ApplicationComponent
      def initialize(**options)
        @options = options
      end

      erb_template <<~ERB
        <div class="dropdown__divider", **@options></div>
      ERB
    end
  end
end
