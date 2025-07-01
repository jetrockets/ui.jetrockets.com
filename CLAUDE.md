# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Build and Development
- `npm run dev` - Start the Vite development server
- `npm run build` - Build assets for production
- `npm run standard` - Run JavaScript StandardJS linting

### Rails Commands
- `bin/rails server` - Start Rails development server
- `bin/rails console` - Open Rails console
- `bin/vite dev` - Start Vite dev server (alternative to npm run dev)
- `bin/vite build` - Build Vite assets (alternative to npm run build)

### Quality Assurance
- `bundle exec rubocop` - Run Ruby code style checks
- `bundle exec brakeman` - Run security analysis
- `bundle exec bundler-audit` - Check for vulnerable dependencies
- `bundle exec erb_lint` - Lint ERB templates

## Architecture Overview

This is a Rails 7 application using ViewComponent for component-based UI architecture. The frontend is built with Vite, TailwindCSS, and Stimulus.

### Key Technologies
- **Rails 7.0.8** - Backend framework
- **ViewComponent** - Component-based view layer
- **Vite** - Frontend build tool and dev server
- **TailwindCSS 4.0** - Utility-first CSS framework
- **Stimulus** - JavaScript framework for Rails
- **Turbo** - SPA-like page acceleration
- **Rodauth** - Authentication system

### Component System
The UI is built using a comprehensive component library located in `app/components/ui/`. Each component follows a consistent pattern:

- **Ruby Component Class** (`component.rb`) - Server-side logic and HTML generation
- **CSS Styles** (`component.css`) - Component-specific styles
- **Stimulus Controller** (`component_controller.js`) - Client-side behavior when needed
- **ERB Template** (`component.html.erb`) - HTML structure for complex components

#### Component Architecture
- **Base Class**: `ApplicationComponent` - Inherits from `ViewComponent::Base`
- **Namespace**: All UI components are under `Ui::` module
- **Pattern**: Each component supports variants, sizes, and modifiers through CSS classes
- **Styling**: Uses TailwindCSS utility classes with component-specific CSS for complex styling

#### Available Components
- **Navigation**: navbar, breadcrumbs, tabs, accordion
- **Forms**: btn, btn_group, form controls with Stimulus integration
- **Layout**: card, drawer, modal, table
- **Feedback**: alert, flash, tooltip, popover
- **Data**: table with pagination (pagy), clipboard
- **Interactive**: dropdown, turbo_confirm

### Frontend Structure
- **Assets**: `app/assets/` contains Stimulus controllers, stylesheets, and images
- **Entry Points**: `app/assets/entrypoints/` for Vite entry files
- **Controllers**: `app/assets/controllers/` for Stimulus controllers
- **Utilities**: `app/assets/utils/` for JavaScript utilities

### Authentication
Uses Rodauth for authentication with the following features enabled:
- User registration and login
- Password reset functionality
- Account verification
- Multi-phase login support

### Development Tools
- **Ui** - Component preview and documentation (available at `/ui` in development)
- **Letter Opener** - Preview emails in development
- **Annotate** - Auto-generate model schema annotations

## File Organization

### Component Structure
```
app/components/ui/[component_name]/
├── component.rb          # Main component class
├── component.html.erb    # Template (if needed)
├── component.css         # Styles
├── component_controller.js # Stimulus controller (if needed)
└── [nested_components]/  # Sub-components
```

### Asset Structure
```
app/assets/
├── controllers/          # Stimulus controllers
├── entrypoints/         # Vite entry points
├── stylesheets/         # CSS files and component styles
├── images/              # Static images and icons
└── utils/               # JavaScript utilities
```

## Testing and Quality

### Testing Framework
- Uses Rails default testing framework
- Component previews available through Lookbook
- Factory Bot for test data generation

### Code Quality Tools
- **RuboCop** with Rails Omakase configuration
- **ERB Lint** for template linting
- **StandardJS** for JavaScript linting
- **Brakeman** for security scanning
- **Bundler Audit** for dependency vulnerability scanning

## Development Workflow

1. **Component Development**: Create new UI components in `app/components/ui/` following the established pattern
2. **Styling**: Use TailwindCSS utilities with component-specific CSS when needed
3. **JavaScript**: Add Stimulus controllers for interactive behavior
4. **Previews**: Use Lookbook for component development and testing
5. **Quality**: Run linting and security tools before committing

## Key Patterns

### Component Initialization
Components typically accept configuration options like `variant`, `size`, `href`, and boolean modifiers:
```ruby
def initialize(variant: nil, size: :md, href: nil, **options)
```

### CSS Class Management
Uses Rails' `class_names` helper to conditionally apply CSS classes based on component state and options.

### Icon Integration
Icons are integrated using `vite_svg_tag` helper for SVG assets managed by Vite.
