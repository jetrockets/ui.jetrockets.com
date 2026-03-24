# JetRockets UI Autocomplete

VSCode extension that provides intelligent autocomplete for JetRockets UI components based on `component.yml` definitions.

## Features

- **Component autocomplete** - Type `ui.` to see all available components
- **Slot autocomplete** - Slots like `ui.alert_title` are also suggested
- **Props autocomplete** - After component name, get suggestions for available props
- **Value autocomplete** - Props with predefined values show dropdown (e.g., `variant: :default`)
- **Hover documentation** - Hover over `ui.btn` to see full documentation
- **Auto-refresh** - Changes to `component.yml` files are detected automatically

## Installation

### Development Installation

1. Install dependencies:
   ```bash
   cd vscode-extension
   npm install
   ```

2. Package the extension:
   ```bash
   npm install -g @vscode/vsce
   vsce package
   ```

3. Install the `.vsix` file:
   - Open VSCode
   - Press `Cmd+Shift+P` → "Extensions: Install from VSIX..."
   - Select the generated `.vsix` file

### Quick Development Testing

1. Open this folder in VSCode
2. Press `F5` to launch Extension Development Host
3. Open a project with `app/components/ui/*/component.yml` files
4. Edit any `.erb` file and type `ui.`

## Usage

### Component Autocomplete

```erb
<%= ui.| %>
       ↓
       ┌─────────────────────────────────┐
       │ btn      Button component       │
       │ alert    Display messages       │
       │ card     Card container         │
       │ badge    Status badge           │
       │ icon     Display SVG icons      │
       └─────────────────────────────────┘
```

### Props Autocomplete

```erb
<%= ui.btn "Click", | %>
                    ↓
                    ┌──────────────────────────────┐
                    │ variant  Symbol (:default)   │
                    │ size     Symbol (:md)        │
                    │ url      String (nil)        │
                    │ rounded  Boolean (false)     │
                    │ block    Boolean (false)     │
                    └──────────────────────────────┘
```

### Value Autocomplete

```erb
<%= ui.btn "Click", variant: :| %>
                              ↓
                              ┌─────────────┐
                              │ default     │
                              │ outline     │
                              │ secondary   │
                              │ danger      │
                              │ ghost       │
                              │ link        │
                              └─────────────┘
```

### Hover Documentation

Hover over any `ui.component_name` to see:
- Description
- Props table with types, defaults, and values
- Usage example

## Configuration

In VSCode settings (`settings.json`):

```json
{
  "jetrocketsUI.componentsPath": "app/components/ui",
  "jetrocketsUI.helperPrefix": "ui."
}
```

## How It Works

The extension reads `component.yml` files from your components directory and builds an in-memory index. The YAML structure expected:

```yaml
name: Button
description: Button component for actions

props:
  - name: variant
    type: Symbol
    default: ":default"
    values:
      - ":default"
      - ":outline"
    description: Visual style

slots:
  - name: btn_icon
    description: Icon slot
    props:
      - name: position
        type: Symbol
        values: [":left", ":right"]

accepts_html_attributes: true
```

## Supported Features

| Feature | Status |
|---------|--------|
| Component names | Yes |
| Slot names (e.g., `alert_title`) | Yes |
| Props with types | Yes |
| Props with values (enum) | Yes |
| Boolean props | Yes |
| String/Integer props | Yes |
| `class` prop (when `accepts_html_attributes: true`) | Yes |
| Hover documentation | Yes |
| File watching | Yes |

## Development

```bash
# Install dependencies
npm install

# Run tests
npm test

# Package
vsce package
```

## License

MIT
