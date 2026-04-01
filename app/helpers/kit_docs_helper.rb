module KitDocsHelper
  def render_kit_block(variant, category_key)
    source_path = Rails.root.join("app/views/ui/kit/#{category_key}/#{variant[:filename]}")
    code = File.read(source_path).strip
    modal_id = "code-#{category_key}-#{variant[:number]}"

    content_tag :div, class: "kit-block", id: "variant-#{variant[:number]}" do
      safe_join([
        ui.card(class: "overflow-hidden") do
          safe_join([
            ui.card_header(justify: :between, align: :center, direction: :row) do
              safe_join([
                ui.card_title("Variant #{variant[:number]}"),
                ui.btn(variant: :secondary, size: :sm, data: { action: "click->modals#show", id: modal_id }) do
                  safe_join([
                    ui.icon("code-bracket", class: "size-4"),
                    content_tag(:span, "View code")
                  ])
                end
              ])
            end,
            content_tag(:div, class: "kit-block-preview") {
              render partial: variant[:partial]
            }
          ])
        end,
        ui.modal(title: "Variant #{variant[:number]} — Source code", id: modal_id, size: "5xl") do
          ui.modal_body do
            content_tag(:pre, content_tag(:code, html_escape(code)), class: "text-sm")
          end
        end
      ])
    end
  end
end
