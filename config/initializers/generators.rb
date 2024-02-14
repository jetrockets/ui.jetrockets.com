# frozen_string_literal: true

Rails.application.config.generators do |g|
  g.integration_tool :rspec

  g.test_framework :rspec,
    fixtures: false,
    view_specs: false,
    routing_specs: false,
    helper_specs: false

  g.fixture_replacement :factory_bot

  g.helper false
end
