class Ui::Dialog::Component < ApplicationComponent
  SIZES = %w[sm md lg xl 2xl 3xl 4xl 5xl 6xl].freeze
  DEFAULT_SIZE = "2xl"

  POSITIONS = %i[center left right top bottom].freeze
  DEFAULT_POSITION = :center

  EDGE_POSITIONS = %i[left right top bottom].freeze

  def initialize(title: nil, subtitle: nil, position: DEFAULT_POSITION, size: DEFAULT_SIZE, id: nil, closable: true, dismissible: true, swipe: true)
    super()
    @title = title
    @subtitle = subtitle
    @position = position.to_sym
    @size = size.to_s
    @id = id
    @closable = closable
    @dismissible = dismissible
    @swipe = swipe && edge_position?
  end

  erb_template <<~ERB
    <%= container_tag do %>
      <div class="dialog__panel" data-dialog-target="panel">
        <%= helpers.ui.dialog_header(title: @title, subtitle: @subtitle, closable: closable?) %>
        <%= content %>
        <div class="dialog__flash-slot"></div>
      </div>
    <% end %>
  ERB

  private

  def edge_position?
    EDGE_POSITIONS.include?(@position)
  end

  def container_tag
    # If @id is provided, we assume it's a sync dialog defined inline on the page.
    if @id
      return dialog_tag id: @id, data: { dialogs_target: "dialog" } do
        yield
      end
    end

    # Async open (for example, opened via a link with data: { turbo_frame: :dialog }).
    # The dialog shell around this frame is created client-side by DialogsController
    # before Turbo navigates the frame — see app/components/ui/dialog/dialogs_controller.js.
    if helpers.turbo_frame_request?
      turbo_frame_tag :dialog do
        yield
      end
    # Not a Turbo Frame request (direct visit, new tab) — render as a plain page section.
    else
      content_tag :div, class: class_names("dialog-page", size_class) do
        yield
      end
    end
  end

  def dialog_tag(options = {})
    content_tag :dialog, tabindex: "-1", class: dialog_classes, data: dialog_data(options.delete(:data)), **options do
      yield
    end
  end

  def dialog_classes
    class_names("dialog", "dialog--#{@position}", size_class)
  end

  def dialog_data(extra)
    {
      controller: "dialog",
      dialog_position_value: @position,
      dialog_dismissible_value: @dismissible,
      dialog_swipe_value: @swipe
    }.merge(extra || {})
  end

  def size_class
    horizontal_edge? ? "h-#{@size}" : "w-#{@size}"
  end

  def horizontal_edge?
    %i[top bottom].include?(@position)
  end

  def closable?
    @closable && (helpers.turbo_frame_request? || @id)
  end
end
