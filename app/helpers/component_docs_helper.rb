module ComponentDocsHelper
  def component_docs(component_name)
    @component_docs_cache ||= {}
    @component_docs_cache[component_name] ||= load_component_docs(component_name)
  end

  def render_component_preview(component_name)
    docs = component_docs(component_name)
    preview = docs&.fetch("preview", nil)
    return nil if preview.blank? || preview == false

    ui.card do
      ui.card_body do
        render(inline: preview)
      end
    end
  end

  def render_component_usage(component_name)
    docs = component_docs(component_name)
    usage = docs&.fetch("usage", nil)
    return nil if usage.blank?

    content_tag(:pre, content_tag(:code, html_escape(usage.strip)))
  end

  def render_component_examples(component_name)
    docs = component_docs(component_name)
    examples = docs&.fetch("examples", [])
    return nil if examples.blank?

    content_tag :div, class: "flex flex-col gap-6" do
      examples.each do |example|
        concat render_example_block(example)
      end
    end
  end

  def render_example_block(example)
    show_preview = example.fetch("preview", true)

    content_tag :div, class: "flex flex-col gap-3" do
      concat content_tag(:h3, example["name"], class: "font-medium text-gray-900")
      if show_preview
        concat(ui.card do
          ui.card_body class: "flex flex-col gap-4" do
            render(inline: example["code"])
          end
        end)
      end
      concat content_tag(:pre, content_tag(:code, html_escape(example["code"].strip)), class: "text-sm")
    end
  end

  def render_props_table(component_name)
    docs = component_docs(component_name)
    return nil unless docs

    props = docs["props"] || []
    return nil if props.blank?

    accepts_html = docs["accepts_html_attributes"]

    ui.card do
      safe_join([
        ui.card_header { ui.card_title("Props") },
        ui.card_body do
          ui.table(size: :xs) do
            safe_join([
              ui.table_thead do
                ui.table_tr do
                  safe_join(%w[Prop Type Default Description].map { |h| ui.table_th(h) })
                end
              end,
              ui.table_tbody do
                safe_join(props.map { |prop| render_prop_row(prop) })
              end
            ])
          end
        end,
        accepts_html ? render_html_attributes_footer : nil
      ].compact)
    end
  end

  def render_subcomponents_table(component_name)
    docs = component_docs(component_name)
    slots = docs&.fetch("slots", [])
    return nil if slots.blank?

    ui.card do
      safe_join([
        ui.card_header { ui.card_title("Subcomponents") },
        ui.card_body do
          ui.table(size: :xs) do
            safe_join([
              ui.table_thead do
                ui.table_tr do
                  safe_join(%w[Name Helper Description].map { |h| ui.table_th(h) })
                end
              end,
              ui.table_tbody do
                safe_join(slots.map { |slot| render_slot_row(slot) })
              end
            ])
          end
        end
      ])
    end
  end

  private

  def load_component_docs(component_name)
    paths = [
      Rails.root.join("app/components/ui/#{component_name}/component.yml"),
      Rails.root.join("app/components/form_builders/#{component_name}/component.yml")
    ]

    path = paths.find { |p| File.exist?(p) }
    return nil unless path

    YAML.safe_load(File.read(path))
  end

  def render_html_attributes_footer
    ui.card_footer do
      content_tag(:p, class: "text-sm text-gray-500") do
        "Also accepts any HTML attributes via ".html_safe +
          content_tag(:code, "**options", class: "text-xs") +
          " (e.g., ".html_safe +
          content_tag(:code, "id:,", class: "text-xs") +
          " ".html_safe +
          content_tag(:code, "data:,", class: "text-xs") +
          " ".html_safe +
          content_tag(:code, "aria:,", class: "text-xs") +
          " ".html_safe +
          content_tag(:code, "class:", class: "text-xs") +
          "). ".html_safe +
          content_tag(:code, "class:", class: "text-xs") +
          " is also supported for custom styling.".html_safe
      end
    end
  end

  def render_prop_row(prop)
    ui.table_tr do
      safe_join([
        ui.table_td { content_tag(:code, prop["name"], class: "text-pink-600") },
        ui.table_td { render_prop_type(prop) },
        ui.table_td { content_tag(:code, prop["default"] || "-", class: "text-gray-500 text-xs") },
        ui.table_td(prop["description"])
      ])
    end
  end

  def render_prop_type(prop)
    type_html = content_tag(:code, prop["type"], class: "text-blue-600 text-xs")

    if prop["values"].present?
      values_html = prop["values"].map { |v| content_tag(:code, v, class: "text-xs text-gray-500") }.join(" | ").html_safe
      safe_join([type_html, tag.br, values_html])
    else
      type_html
    end
  end

  def render_slot_row(slot)
    ui.table_tr do
      safe_join([
        ui.table_td { content_tag(:code, slot["name"], class: "text-pink-600") },
        ui.table_td { content_tag(:code, "ui.#{slot['name']}", class: "text-xs text-gray-500") },
        ui.table_td(slot["description"])
      ])
    end
  end
end
