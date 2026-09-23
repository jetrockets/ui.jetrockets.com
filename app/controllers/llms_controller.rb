# LLM-native documentation surface.
#
#   GET /llms.txt                 → curated index (links to per-component markdown)
#   GET /llms-full.txt            → entire component corpus inlined, single fetch
#   GET /ui/components/:name.md   → one component as plain markdown
#
# All output is generated live from the same `component.yml` files that
# power the human docs (see ComponentCatalog / ComponentMarkdown), so it
# can never drift and needs no build step.
class LlmsController < ApplicationController
  MARKDOWN = "text/markdown; charset=utf-8".freeze

  def index
    render plain: index_document, content_type: MARKDOWN
  end

  def full
    render plain: full_document, content_type: MARKDOWN
  end

  def component
    # The route's format constraint still admits extensionless URLs, so
    # enforce the documented `.md` contract here.
    return head(:not_found) unless params[:format] == "md"

    entry = ComponentCatalog.find(params[:name])
    return head(:not_found) unless entry

    render plain: ComponentMarkdown.call(entry), content_type: MARKDOWN
  end

  private

  def index_document
    entries = ComponentCatalog.all
    sections = {
      "Components" => entries.select(&:component?),
      "Form Builders" => entries.reject(&:component?)
    }

    out = [
      "# JetRockets UI",
      "",
      "A Rails ViewComponent library. Render components with the `ui` helper, " \
        "e.g. `<%= ui.btn(\"Save\", variant: :default) %>`. " \
        "Fetch #{llms_full_url} for the complete API in one document."
    ]

    sections.each do |title, entries|
      next if entries.empty?

      out << "" << "## #{title}" << ""
      entries.each do |entry|
        url = llms_component_url(name: entry.name, format: :md)
        out << "- [#{entry.title}](#{url}): #{entry.description}"
      end
    end

    out.join("\n") + "\n"
  end

  def full_document
    header = [
      "# JetRockets UI — Full Reference",
      "",
      "Rails ViewComponent library. Render with the `ui` helper.",
      ""
    ].join("\n")

    body = ComponentCatalog.all.map { |entry| ComponentMarkdown.call(entry) }
    header + "\n" + body.join("\n---\n\n")
  end
end
