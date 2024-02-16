module MetaTagsHelper
  def default_meta_tags
    og_title = meta_tags[:title] || default_title
    og_description = meta_tags[:description] || default_description

    {
      site: site_name,
      title: default_title,
      description: default_description,
      keywords: default_keywords,
      canonical: request.original_url,
      reverse: true,
      og: {
        title: og_title,
        type: "website",
        description: og_description,
        image: {
          _: vite_asset_url_with_host("images/og.jpg"),
          width: 1200,
          height: 630
        },
        url: request.url,
        site_name: site_name,
        locale: :en_US
      },
      twitter: {
        card: "summary_large_image",
        site: "@twitter_account",
        title: og_title,
        description: og_description,
        image: vite_asset_url_with_host("images/og.jpg"),
        url: request.url
      }
    }
  end

  private

  def site_name
    "Site Name"
  end

  def default_title
    "Default Title"
  end

  def default_description
    "Default Description"
  end

  def default_keywords
    "Default keywords"
  end
end
