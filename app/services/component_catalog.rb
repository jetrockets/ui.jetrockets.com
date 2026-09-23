# Single source of truth for LLM-facing docs.
#
# Scans the same `component.yml` files that power the human docs
# (rendered by ComponentDocsHelper), so the llms.txt / *.md output can
# never drift from the website — there is nothing extra to regenerate.
class ComponentCatalog
  SOURCES = [
    { category: :component, root: "app/components/ui" },
    { category: :form,      root: "app/components/form_builders" }
  ].freeze

  Entry = Struct.new(:name, :category, :data, keyword_init: true) do
    def title       = data["name"].presence || name.humanize
    def description = data["description"].to_s.strip
    def component?  = category == :component
  end

  class << self
    def all
      SOURCES.flat_map { |src| load_source(src) }.sort_by(&:name)
    end

    def components = all.select(&:component?)
    def forms      = all.reject(&:component?)

    def find(name)
      all.find { |e| e.name == name.to_s }
    end

    private

    def load_source(src)
      Dir.glob(Rails.root.join(src[:root], "*/component.yml")).filter_map do |path|
        data = load_yaml(path)
        next if data.blank?

        Entry.new(name: File.basename(File.dirname(path)), category: src[:category], data: data)
      end
    end

    # A syntax error in one component.yml must not take down the whole
    # corpus endpoint — skip the bad file and keep serving the rest.
    def load_yaml(path)
      YAML.safe_load(File.read(path))
    rescue Psych::SyntaxError => e
      Rails.logger.warn("[ComponentCatalog] skipping #{path}: #{e.message}")
      nil
    end
  end
end
