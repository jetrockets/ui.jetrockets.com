# Rails UI Component Library

A comprehensive Rails 7 component library template built with ViewComponent, TailwindCSS 4.0, and Stimulus. This template provides a complete set of reusable UI components that developers can copy and customize for their projects.

## 🚀 Quick Start

### Requirements

- **Ruby** 3.2.3+
- **Rails** 7.0.8+
- **Node.js** 18+
- **ViewComponent** gem
- **TailwindCSS** 4.0

### Installation

1. Clone or download this template
2. Copy the components you need to your Rails project
3. Ensure you have the required dependencies in your `Gemfile`:

```ruby
gem 'view_component'
gem 'vite_rails'
gem 'turbo-rails'
gem 'pagy', '~> 9.3.4'
```

4. Install frontend dependencies:
```bash
yarn install
```

5. Start development:
```bash
bin/rails server
yarn dev  # or bin/vite dev
```

## 📦 Component Library

### Navigation Components
- **Accordion** - Collapsible content sections with smooth animations
- **Dropdown** - Customizable dropdown menus with keyboard navigation
- **Tabs** - Horizontal tab navigation with active states

### Form Components
- **Button (`btn`)** - Multiple variants (primary, secondary, outline) and sizes
- **Button Group (`btn_group`)** - Grouped button layouts
- **Turbo Confirm** - Confirmation dialogs with Turbo integration

### Layout Components
- **Card** - Container component with header and footer variants
- **Drawer** - Slide-out panels for navigation or content
- **Modal** - Overlay dialogs with backdrop and animations
- **Table** - Responsive tables with sorting and pagination support

### Feedback Components
- **Alert** - Status messages with dismissible functionality
- **Badge** - Small status indicators and labels
- **Flash** - System notifications with auto-dismiss
- **Tooltip** - Hover information popups

### Interactive Components
- **Avatar** - User profile images with fallbacks
- **Clipboard** - Copy-to-clipboard functionality
- **Icon** - SVG icon system with Vite integration
- **Popover** - Rich content popovers with positioning
- **Pagy** - Pagination component with multiple styles

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
  def initialize(variant: :primary, size: :md, **options)
    @variant = variant
    @size = size
    @options = options
  end
end
```

## 💡 Usage Examples

### Basic Button
```erb
<%= render Ui::Btn::Component.new(variant: :primary, size: :lg) do %>
  Click me
<% end %>
```

### Card with Header and Footer
```erb
<%= render Ui::Card::Component.new do %>
  <%= render Ui::Card::Header::Component.new do %>
    Card Title
  <% end %>

  <p>Card content goes here</p>

  <%= render Ui::Card::Footer::Component.new do %>
    <div class="flex justify-end gap-2">
      <%= render Ui::Btn::Component.new(variant: :secondary) { "Cancel" } %>
      <%= render Ui::Btn::Component.new(variant: :primary) { "Save" } %>
    </div>
  <% end %>
<% end %>
```

### Table with Pagination
```erb
<%= render Ui::Table::Component.new do %>
  <%= render Ui::Table::Thead::Component.new do %>
    <%= render Ui::Table::Tr::Component.new do %>
      <%= render Ui::Table::Th::Component.new { "Name" } %>
      <%= render Ui::Table::Th::Component.new { "Email" } %>
      <%= render Ui::Table::Th::Component.new { "Actions" } %>
    <% end %>
  <% end %>

  <%= render Ui::Table::Tbody::Component.new do %>
    <% @users.each do |user| %>
      <%= render Ui::Table::Tr::Component.new do %>
        <%= render Ui::Table::Td::Component.new { user.name } %>
        <%= render Ui::Table::Td::Component.new { user.email } %>
        <%= render Ui::Table::Td::Component.new do %>
          <%= render Ui::Btn::Component.new(size: :sm, variant: :outline) { "Edit" } %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>
<% end %>

<%= render Ui::Pagy::Component.new(pagy: @pagy) %>
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
def initialize(variant: :primary, size: :md, **options)
  @variant = variant
  @size = size
end

private

def css_classes
  class_names(
    "btn",
    "btn--#{@variant}",
    "btn--#{@size}",
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
│   ├── btn_group/          # Button group component
│   ├── card/               # Card component with sub-components
│   ├── clipboard/          # Clipboard component
│   ├── drawer/             # Drawer component
│   ├── dropdown/           # Dropdown component with sub-components
│   ├── flash/              # Flash message component
│   ├── icon/               # Icon component
│   ├── modal/              # Modal component
│   ├── pagy/               # Pagination component
│   ├── popover/            # Popover component with sub-components
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

- **Rails 7.0.8** - Backend framework with modern features
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
