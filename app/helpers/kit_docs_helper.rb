module KitDocsHelper
  def render_kit_block(variant, category_key)
    content_tag :div, class: "kit-block flex flex-col gap-4", id: "variant-#{variant[:number]}" do
      safe_join([
        render_kit_block_header(variant),
        render_kit_block_preview(variant),
        render_kit_block_code(variant, category_key)
      ])
    end
  end

  private

  def render_kit_block_header(variant)
    content_tag :div, class: "flex items-center justify-between" do
      content_tag :h3, "Variant #{variant[:number]}", class: "font-medium text-muted-foreground"
    end
  end

  def render_kit_block_preview(variant)
    ui.card do
      ui.card_body do
        render partial: variant[:partial]
      end
    end
  end

  def render_kit_block_code(variant, category_key)
    source_path = Rails.root.join("app/views/ui/kit/#{category_key}/#{variant[:filename]}")
    code = File.read(source_path).strip

    content_tag :details, class: "group" do
      safe_join([
        content_tag(:summary, class: "cursor-pointer text-sm text-muted-foreground hover:text-foreground flex items-center gap-1") {
          safe_join([
            ui.icon("code-bracket", class: "size-4"),
            content_tag(:span, "View code")
          ])
        },
        content_tag(:pre, content_tag(:code, html_escape(code)), class: "text-sm mt-2")
      ])
    end
  end
end
