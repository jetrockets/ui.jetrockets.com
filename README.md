# Rails UI Component Library

A comprehensive Rails 7 component library built with ViewComponent, TailwindCSS 4.0, and Stimulus. This template provides a complete set of reusable UI components that developers can copy and customize for their projects.

## 🚀 Quick Start

### Requirements

- **Ruby** 3.4.4+
- **Rails** 7.0+
- **Node.js** 18+
- **ViewComponent** gem
- **TailwindCSS** 4.0

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd ui.jetrockets.com
```

2. Install dependencies:
```bash
bundle install
yarn install
```

3. Setup database:
```bash
bin/rails db:setup
```

4. Start development servers:
```bash
bin/rails server
yarn dev  # or bin/vite dev
```

## 🏗️ Architecture

### Component Structure
Each component follows a consistent pattern:

```
app/components/ui/[component_name]/
├── component.rb          # Main component class
├── component.html.erb    # Template (when needed)
├── component.css         # Component-specific styles
├── component_controller.js # Stimulus controller (when needed)
└── [nested_components]/  # Sub-components
```

### Key Features
- **ViewComponent Integration** - Server-side component rendering
- **TailwindCSS 4.0** - Utility-first CSS with custom component styles
- **Stimulus Controllers** - Client-side behavior and interactivity
- **Turbo Compatible** - Works seamlessly with Turbo Drive and Frames
- **Responsive Design** - Mobile-first responsive components
- **Accessibility** - ARIA attributes and keyboard navigation support

### Base Architecture
All components inherit from `ApplicationComponent` which extends `ViewComponent::Base`:

```ruby
class ApplicationComponent < ViewComponent::Base
  # Shared component functionality
end
```

Components are namespaced under the `Ui::` module:

```ruby
class Ui::Button::Component < ApplicationComponent
  def initialize(variant: :default, size: :md, **options)
    @variant = variant
    @size = size
    @options = options
  end
end
```

## 💡 Usage Examples

### Basic Button
```erb
<%= ui.btn "Click me" %>
```

### Card with Header and Footer
```erb
<%= ui.card do %>
  <%= ui.card_header do %>
    <%= ui.card_title do %>Card Title<% end %>
  <% end %>

  <%= ui.card_body do %>
    <p>Card content goes here</p>
  <% end %>

  <%= ui.card_footer do %>
    <div class="flex justify-end gap-2">
      <%= ui.btn variant: :secondary do %>Cancel<% end %>
      <%= ui.btn variant: :default do %>Save<% end %>
    </div>
  <% end %>
<% end %>
```

### Table with Pagination
```erb
<%= ui.table do %>
  <%= ui.table_thead do %>
    <%= ui.table_tr do %>
      <%= ui.table_th { "Name" } %>
      <%= ui.table_th { "Email" } %>
      <%= ui.table_th { "Actions" } %>
    <% end %>
  <% end %>

  <%= ui.table_tbody do %>
    <% @users.each do |user| %>
      <%= ui.table_tr do %>
        <%= ui.table_td { user.name } %>
        <%= ui.table_td { user.email } %>
        <%= ui.table_td do %>
          <%= ui.btn("Edit", size: :sm, variant: :outline) %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>

<%= ui.pagy(pagy: @pagy) %>
```

## 🛠️ Development Workflow

### Customizing Components
1. Copy the component folder to your project
2. Modify the CSS classes in `component.css`
3. Adjust the Ruby logic in `component.rb`
4. Update Stimulus behavior in `component_controller.js`

### Adding New Variants
Components support variants through CSS classes:

```ruby
def initialize(variant: :default, size: :md, **options)
  @variant = variant
  @size = size
end

private

def css_classes
  class_names(
    "btn",
    "btn-#{@variant}",
    "btn-#{@size}",
    @options[:class]
  )
end
```

### Styling Guidelines
- Use TailwindCSS utilities for basic styling
- Create component-specific CSS for complex interactions
- Follow BEM-like naming for component CSS classes
- Maintain responsive design principles

## 🔧 Development Commands

### Build and Development
```bash
yarn dev          # Start Vite development server
yarn build        # Build assets for production
yarn standard     # Run JavaScript StandardJS linting
```

### Rails Commands
```bash
bin/rails server     # Start Rails development server
bin/rails console    # Open Rails console
bin/vite dev         # Alternative Vite dev server
bin/vite build       # Alternative Vite build
```

### Quality Assurance
```bash
bundle exec rubocop          # Ruby code style checks
bundle exec brakeman         # Security analysis
bundle exec bundler-audit    # Vulnerability checks
bundle exec erb_lint         # ERB template linting
```

## 📁 File Structure

```
app/
├── components/ui/           # UI Components library
│   ├── accordion/          # Accordion component
│   ├── alert/              # Alert component
│   ├── avatar/             # Avatar component
│   ├── badge/              # Badge component
│   ├── btn/                # Button component
│   ├── card/               # Card component with sub-components
│   ├── clipboard/          # Clipboard component
│   ├── drawer/             # Drawer component
│   ├── dropdown/           # Dropdown component with sub-components
│   ├── empty/              # Empty state component with sub-components
│   ├── flash/              # Flash message component
│   ├── group/              # Button group component
│   ├── header/             # Page header component with sub-components
│   ├── icon/               # Icon component
│   ├── modal/              # Modal component
│   ├── pagy/               # Pagination component
│   ├── popover/            # Popover component with sub-components
│   ├── spinner/            # Loading spinner component
│   ├── table/              # Table component with sub-components
│   ├── tabs/               # Tabs component
│   ├── tooltip/            # Tooltip component
│   └── turbo_confirm/      # Turbo confirmation component
├── assets/
│   ├── controllers/        # Stimulus controllers
│   ├── entrypoints/        # Vite entry points
│   └── stylesheets/        # Global styles
└── views/
    └── layouts/            # Application layouts
```

## 🎯 Key Technologies

- **Rails 8.0** - Backend framework with modern features
- **ViewComponent** - Component-based architecture for views
- **Vite** - Fast build tool for frontend assets
- **TailwindCSS 4.0** - Utility-first CSS framework
- **Stimulus** - Modest JavaScript framework
- **Turbo** - SPA-like page acceleration
- **Pagy** - Fast pagination gem
- **Rodauth** - Authentication framework (in template)

## 📝 Contributing

When using this template:

1. **Copy Components** - Take only what you need for your project
2. **Customize Styling** - Adapt colors, spacing, and styling to your brand
3. **Extend Functionality** - Add new variants and features as needed
4. **Follow Patterns** - Maintain the established component architecture
5. **Test Thoroughly** - Ensure components work in your specific use case

## 📄 License

This template is open source and available for use in your projects. Components can be freely copied, modified, and distributed.

## 🤝 Support

This is a template library designed for copying components into your projects. Each component is self-contained and can be adapted to your needs.

For issues or questions about specific implementations, refer to the documentation of the underlying technologies (Rails, ViewComponent, TailwindCSS, Stimulus).
