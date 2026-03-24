const vscode = require('vscode')
const fs = require('fs')
const path = require('path')
const yaml = require('js-yaml')

let componentsCache = null
let slotsCache = null

function activate(context) {
  console.log('JetRockets UI Autocomplete activated')

  // Load components on activation
  loadAllComponents()

  // Watch for changes in component.yml files
  const watcher = vscode.workspace.createFileSystemWatcher('**/app/components/ui/*/component.yml')
  watcher.onDidChange(() => loadAllComponents())
  watcher.onDidCreate(() => loadAllComponents())
  watcher.onDidDelete(() => loadAllComponents())
  context.subscriptions.push(watcher)

  // Register completion provider for ERB files
  const provider = vscode.languages.registerCompletionItemProvider(
    [
      { language: 'erb' },
      { language: 'html.erb' },
      { pattern: '**/*.html.erb' },
      { pattern: '**/*.erb' }
    ],
    new UICompletionProvider(),
    '.', ' ', ',', ':'
  )

  // Register hover provider for documentation
  const hoverProvider = vscode.languages.registerHoverProvider(
    [
      { language: 'erb' },
      { language: 'html.erb' },
      { pattern: '**/*.html.erb' },
      { pattern: '**/*.erb' }
    ],
    new UIHoverProvider()
  )

  context.subscriptions.push(provider, hoverProvider)
}

function loadAllComponents() {
  const workspaceRoot = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath
  if (!workspaceRoot) return

  const config = vscode.workspace.getConfiguration('jetrocketsUI')
  const componentsPath = path.join(workspaceRoot, config.get('componentsPath', 'app/components/ui'))

  componentsCache = new Map()
  slotsCache = new Map()

  if (!fs.existsSync(componentsPath)) return

  fs.readdirSync(componentsPath).forEach(dir => {
    const ymlPath = path.join(componentsPath, dir, 'component.yml')
    if (fs.existsSync(ymlPath)) {
      try {
        const content = yaml.load(fs.readFileSync(ymlPath, 'utf8'))
        const component = parseComponent(dir, content)
        componentsCache.set(dir, component)

        // Also cache slots as separate completions (e.g., ui.alert_title)
        if (content.slots) {
          content.slots.forEach(slot => {
            slotsCache.set(slot.name, {
              name: slot.name,
              description: slot.description,
              parentComponent: dir,
              props: slot.props || [],
              component: slot.component
            })
          })
        }
      } catch (e) {
        console.error(`Error parsing ${ymlPath}:`, e)
      }
    }
  })

  console.log(`Loaded ${componentsCache.size} components and ${slotsCache.size} slots`)
}

function parseComponent(name, content) {
  return {
    name,
    displayName: content.name || name,
    description: content.description || '',
    props: content.props || [],
    slots: content.slots || [],
    content: content.content,
    acceptsHtmlAttributes: content.accepts_html_attributes || false,
    usage: content.usage || '',
    preview: content.preview || '',
    examples: content.examples || []
  }
}

class UICompletionProvider {
  provideCompletionItems(document, position, token, context) {
    if (!componentsCache) return []

    const lineText = document.lineAt(position).text
    const linePrefix = lineText.substring(0, position.character)

    // Check if we're inside ERB tags
    if (!this.isInsideErb(linePrefix)) return []

    const config = vscode.workspace.getConfiguration('jetrocketsUI')
    const prefix = config.get('helperPrefix', 'ui.')

    // 1. Trigger on "ui." - show all components and slots
    if (linePrefix.endsWith(prefix)) {
      return this.getComponentCompletions()
    }

    // 2. Trigger on prop value after colon (e.g., "variant: :")
    const colonMatch = linePrefix.match(/(\w+):\s*:(\w*)$/)
    if (colonMatch) {
      return this.getPropValueCompletions(linePrefix, colonMatch[1], colonMatch[2])
    }

    // 3. Trigger on props (after component name and first argument)
    const propsMatch = linePrefix.match(/ui\.(\w+)(?:\s+["'][^"']*["'])?(?:\s*,\s*|\s+)(\w*)$/)
    if (propsMatch) {
      const componentName = propsMatch[1]
      const partialProp = propsMatch[2]
      return this.getPropCompletions(componentName, partialProp, linePrefix)
    }

    // 4. Partial component name after "ui."
    const partialMatch = linePrefix.match(/ui\.(\w+)$/)
    if (partialMatch) {
      return this.getComponentCompletions(partialMatch[1])
    }

    return []
  }

  isInsideErb(linePrefix) {
    const lastOpen = linePrefix.lastIndexOf('<%')
    const lastClose = linePrefix.lastIndexOf('%>')
    return lastOpen > lastClose
  }

  getComponentCompletions(filter = '') {
    const items = []

    // Add main components
    componentsCache.forEach((component, name) => {
      if (filter && !name.startsWith(filter)) return

      const item = new vscode.CompletionItem(name, vscode.CompletionItemKind.Method)
      item.detail = component.displayName
      item.documentation = this.buildComponentDocs(component)
      item.insertText = this.buildComponentSnippet(component)
      item.sortText = `0_${name}` // Components first
      items.push(item)
    })

    // Add slots (e.g., alert_title, alert_description)
    slotsCache.forEach((slot, name) => {
      if (filter && !name.startsWith(filter)) return

      const item = new vscode.CompletionItem(name, vscode.CompletionItemKind.Function)
      item.detail = `Slot for ${slot.parentComponent}`
      item.documentation = new vscode.MarkdownString(slot.description)
      item.insertText = this.buildSlotSnippet(slot)
      item.sortText = `1_${name}` // Slots after components
      items.push(item)
    })

    return items
  }

  getPropCompletions(componentName, partialProp, linePrefix) {
    // Check both components and slots
    const component = componentsCache.get(componentName) || slotsCache.get(componentName)
    if (!component) return []

    const items = []
    const usedProps = this.getUsedProps(linePrefix)

    component.props.forEach(prop => {
      if (usedProps.has(prop.name)) return
      if (partialProp && !prop.name.startsWith(partialProp)) return

      const item = new vscode.CompletionItem(prop.name, vscode.CompletionItemKind.Property)
      item.detail = `${prop.type}${prop.default ? ` (default: ${prop.default})` : ''}`
      item.documentation = new vscode.MarkdownString(this.buildPropDocs(prop))

      if (prop.values && prop.values.length > 0) {
        // For props with predefined values, create a snippet with choices
        const values = prop.values.map(v => v.replace(/^:/, '')).join(',')
        item.insertText = new vscode.SnippetString(`${prop.name}: :\${1|${values}|}`)
      } else if (prop.type === 'Boolean') {
        item.insertText = new vscode.SnippetString(`${prop.name}: \${1|true,false|}`)
      } else if (prop.type === 'String') {
        item.insertText = new vscode.SnippetString(`${prop.name}: "\${1}"`)
      } else if (prop.type === 'Integer') {
        item.insertText = new vscode.SnippetString(`${prop.name}: \${1:0}`)
      } else {
        item.insertText = new vscode.SnippetString(`${prop.name}: \${1}`)
      }

      items.push(item)
    })

    // Add class prop if component accepts HTML attributes
    if (component.acceptsHtmlAttributes && !usedProps.has('class')) {
      const item = new vscode.CompletionItem('class', vscode.CompletionItemKind.Property)
      item.detail = 'String'
      item.documentation = new vscode.MarkdownString('Additional CSS classes')
      item.insertText = new vscode.SnippetString('class: "${1}"')
      items.push(item)
    }

    return items
  }

  getPropValueCompletions(linePrefix, propName, partialValue) {
    // Find which component we're in
    const componentMatch = linePrefix.match(/ui\.(\w+)/)
    if (!componentMatch) return []

    const componentName = componentMatch[1]
    const component = componentsCache.get(componentName) || slotsCache.get(componentName)
    if (!component) return []

    const prop = component.props.find(p => p.name === propName)
    if (!prop || !prop.values) return []

    return prop.values
      .filter(v => {
        const cleanValue = v.replace(/^:/, '')
        return !partialValue || cleanValue.startsWith(partialValue)
      })
      .map(v => {
        const cleanValue = v.replace(/^:/, '')
        const item = new vscode.CompletionItem(cleanValue, vscode.CompletionItemKind.EnumMember)
        item.detail = prop.name
        item.insertText = cleanValue
        return item
      })
  }

  getUsedProps(linePrefix) {
    const used = new Set()
    const matches = linePrefix.matchAll(/(\w+):/g)
    for (const match of matches) {
      used.add(match[1])
    }
    return used
  }

  buildComponentSnippet(component) {
    const props = component.props || []
    const mainProp = props.find(p => p.values && p.values.length > 0)

    // Check if component typically takes text as first argument
    const takesText = component.content?.description?.toLowerCase().includes('text') ||
                      component.usage?.includes('ui.' + component.name + ' "')

    let snippet = component.name

    if (takesText) {
      snippet += ' "${1:text}"'
      if (mainProp) {
        const values = mainProp.values.map(v => v.replace(/^:/, '')).join(',')
        snippet += `, ${mainProp.name}: :\${2|${values}|}`
      }
    } else if (mainProp) {
      const values = mainProp.values.map(v => v.replace(/^:/, '')).join(',')
      snippet += ` ${mainProp.name}: :\${1|${values}|}`
    }

    return new vscode.SnippetString(snippet)
  }

  buildSlotSnippet(slot) {
    const props = slot.props || []
    let snippet = slot.name

    // Most slots take content as first argument
    snippet += ' "${1}"'

    return new vscode.SnippetString(snippet)
  }

  buildComponentDocs(component) {
    const md = new vscode.MarkdownString()
    md.isTrusted = true

    md.appendMarkdown(`## ${component.displayName}\n\n`)
    md.appendMarkdown(`${component.description}\n\n`)

    if (component.props.length > 0) {
      md.appendMarkdown('### Props\n\n')
      component.props.forEach(prop => {
        const required = prop.required ? ' *(required)*' : ''
        const defaultVal = prop.default ? ` = \`${prop.default}\`` : ''
        md.appendMarkdown(`- **${prop.name}**${required}: \`${prop.type}\`${defaultVal}\n`)
        if (prop.values) {
          md.appendMarkdown(`  - Values: ${prop.values.map(v => `\`${v}\``).join(', ')}\n`)
        }
        md.appendMarkdown(`  - ${prop.description}\n`)
      })
    }

    if (component.slots && component.slots.length > 0) {
      md.appendMarkdown('\n### Slots\n\n')
      component.slots.forEach(slot => {
        md.appendMarkdown(`- **ui.${slot.name}**: ${slot.description}\n`)
      })
    }

    if (component.usage) {
      md.appendMarkdown('\n### Usage\n\n')
      md.appendCodeblock(component.usage.trim(), 'erb')
    }

    return md
  }

  buildPropDocs(prop) {
    let docs = prop.description || ''

    if (prop.values && prop.values.length > 0) {
      docs += `\n\n**Values:** ${prop.values.map(v => `\`${v}\``).join(', ')}`
    }

    if (prop.default) {
      docs += `\n\n**Default:** \`${prop.default}\``
    }

    return docs
  }
}

class UIHoverProvider {
  provideHover(document, position, token) {
    if (!componentsCache) return null

    const range = document.getWordRangeAtPosition(position, /ui\.\w+/)
    if (!range) return null

    const word = document.getText(range)
    const componentName = word.replace('ui.', '')

    const component = componentsCache.get(componentName) || slotsCache.get(componentName)
    if (!component) return null

    const md = new vscode.MarkdownString()
    md.isTrusted = true

    if (component.displayName) {
      // It's a main component
      md.appendMarkdown(`## ${component.displayName}\n\n`)
      md.appendMarkdown(`${component.description}\n\n`)

      if (component.props && component.props.length > 0) {
        md.appendMarkdown('### Props\n\n')
        md.appendMarkdown('| Name | Type | Default | Description |\n')
        md.appendMarkdown('|------|------|---------|-------------|\n')
        component.props.forEach(prop => {
          const values = prop.values ? ` (${prop.values.join(', ')})` : ''
          md.appendMarkdown(`| ${prop.name} | ${prop.type}${values} | ${prop.default || '-'} | ${prop.description} |\n`)
        })
      }

      if (component.usage) {
        md.appendMarkdown('\n### Example\n\n')
        md.appendCodeblock(component.usage.trim(), 'erb')
      }
    } else {
      // It's a slot
      md.appendMarkdown(`## ${component.name}\n\n`)
      md.appendMarkdown(`*Slot for \`ui.${component.parentComponent}\`*\n\n`)
      md.appendMarkdown(`${component.description}\n`)
    }

    return new vscode.Hover(md, range)
  }
}

function deactivate() {
  componentsCache = null
  slotsCache = null
}

module.exports = { activate, deactivate }
