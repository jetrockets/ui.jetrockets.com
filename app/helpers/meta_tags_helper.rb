module MetaTagsHelper
  def site_title
    "Company Name"
  end

  def default_meta_tags
    {
      title: site_title,
      description: "Company description",
      keywords: "Keywords",
      canonical: @canonical || request.original_url,
      og: {
        title: @page_title,
        type: "website",
        description: @page_description,
        image: {
          _: vite_asset_url_with_host("images/og-thumb.jpg"),
          width: 1200,
          height: 630
        },
        url: request.url,
        site_name: site_title,
        locale: :en_US
      },
      twitter: {
        card: "summary_large_image",
        site: "@twitter_account",
        title: @page_title,
        description: @page_description,
        image: vite_asset_url_with_host("images/og-thumb.jpg"),
        url: request.url
      }
    }
  end
end
