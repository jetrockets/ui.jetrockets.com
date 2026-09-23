# Renders one ComponentCatalog::Entry to plain Markdown.
#
# This is the LLM-native mirror of ComponentDocsHelper's HTML output:
# same data (props, slots, usage, examples), flat Markdown instead of
# ViewComponent markup.
class ComponentMarkdown
  def initialize(entry)
    @entry = entry
    @data  = entry.data
  end

  def self.call(entry) = new(entry).call

  def call
    [
      heading,
      usage_section,
      props_section,
      slots_section,
      examples_section
    ].compact.join("\n\n") + "\n"
  end

  private

  attr_reader :entry, :data

  def heading
    out = ["# #{entry.title}"]
    out << entry.description if entry.description.present?
    out.join("\n\n")
  end

  def usage_section
    usage = data["usage"].presence || data["preview"].presence
    return if usage.blank?

    "## Usage\n\n#{erb_block(usage)}"
  end

  def props_section
    table = props_table(Array(data["props"]))
    return if table.nil?

    note = data["accepts_html_attributes"] ? "\n\nAlso accepts any HTML attributes via `**options` (e.g. `id:`, `data:`, `aria:`, `class:`)." : ""
    "## Props\n\n#{table}#{note}"
  end

  def slots_section
    slots = Array(data["slots"])
    return if slots.empty?

    blocks = slots.map do |slot|
      parts = ["### `ui.#{slot['name']}`"]
      parts << inline(slot["description"]) if slot["description"].present?
      props_table = props_table(Array(slot["props"]))
      parts << props_table if props_table
      parts.join("\n\n")
    end

    "## Subcomponents\n\nUse the subcomponents below, or any HTML.\n\n#{blocks.join("\n\n")}"
  end

  # Shared by the top-level Props section and each subcomponent's props,
  # so pipe-escaping and column layout stay consistent. Returns nil when
  # there are no props.
  def props_table(props)
    return if props.empty?

    rows = props.map do |prop|
      type = [prop["type"], format_values(prop["values"])].compact.join(" ")
      "| #{code_cell(prop['name'])} | #{cell(type)} | #{code_cell(prop['default'])} | #{cell(prop['description'])} |"
    end

    ["| Prop | Type | Default | Description |", "|------|------|---------|-------------|", *rows].join("\n")
  end

  def examples_section
    examples = Array(data["examples"])
    return if examples.empty?

    blocks = examples.map do |ex|
      "### #{ex['name']}\n\n#{erb_block(ex['code'])}"
    end

    "## Examples\n\n#{blocks.join("\n\n")}"
  end

  def erb_block(code)
    "```erb\n#{code.to_s.strip}\n```"
  end

  def format_values(values)
    return if values.blank?

    "(#{Array(values).join(', ')})"
  end

  # A plain table cell: single line, pipes escaped so they don't spawn
  # extra columns (e.g. a type of "String | false").
  def cell(text)
    inline(text).gsub("|", "\\|")
  end

  # A code-formatted table cell, or an em dash when blank.
  def code_cell(value)
    value.present? ? "`#{cell(value)}`" : "—"
  end

  def inline(text)
    text.to_s.gsub(/\s+/, " ").strip
  end
end
