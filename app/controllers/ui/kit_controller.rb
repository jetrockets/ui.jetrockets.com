class Ui::KitController < ApplicationController
  CATEGORIES = {
    hero_sections: { title: "Hero Sections", description: "Landing page hero blocks with headlines, CTAs and visuals" },
    feature_sections: { title: "Feature Sections", description: "Showcase product features and capabilities" },
    pricing_tables: { title: "Pricing Tables", description: "Pricing plans and comparison tables" },
    cta_sections: { title: "Call to Action", description: "Encourage users to take action" },
    testimonials: { title: "Testimonials", description: "Customer reviews and social proof" },
    footers: { title: "Footers", description: "Page footer layouts with links and info" },
    team_sections: { title: "Team Sections", description: "Showcase team members and roles" },
    newsletter_sections: { title: "Newsletter", description: "Email subscription and newsletter signup blocks" },
    stats_sections: { title: "Stats & Logos", description: "Statistics, metrics and partner logos" }
  }.freeze

  def index
  end

  def show
    @category_key = params[:category].to_sym
    @category = CATEGORIES[@category_key]

    unless @category
      redirect_to ui_kit_index_path
      return
    end

    @variants = load_variants(@category_key)
  end

  private

  def load_variants(category)
    dir = Rails.root.join("app/views/ui/kit/#{category}")
    return [] unless Dir.exist?(dir)

    Dir.glob(dir.join("_variant_*.html.erb")).sort.map do |path|
      filename = File.basename(path, ".html.erb").delete_prefix("_")
      number = filename.delete_prefix("variant_").to_i
      {
        number: number,
        partial: "ui/kit/#{category}/#{filename}",
        filename: File.basename(path)
      }
    end
  end
end
