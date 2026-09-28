# lumide_typescript

[![pub package](https://img.shields.io/pub/v/lumide_typescript.svg)](https://pub.dev/packages/lumide_typescript) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Powered by SoFluffy](https://img.shields.io/badge/Powered%20by-SoFluffy-orange)](https://sofluffy.io)

The official TypeScript and JavaScript extension for [Lumide IDE](https://lumide.dev).

`lumide_typescript` provides TypeScript and JavaScript support through `typescript-language-server` or TypeScript 7’s native Go language server.

## Features

### 🛠 Modern Web Support
- **IntelliSense**: Intelligent code completions, signatures, and documentation hovers for TS and JS.
- **Diagnostics**: Real-time syntax and semantic errors highlighting.
- **Navigation**: Instant go-to-definition, find references, and symbol search.
- **Project Aware**: Understands `tsconfig.json`, `package.json`, and npm dependency graphs.

### ⚡ TypeScript 7 (Go)
- **Native LSP**: Use the built-in TypeScript 7 server with `tsc --lsp --stdio`.
- **Fast projects**: TypeScript 7 uses native code and parallel processing.
- **Framework plugins**: Use legacy for Vue, Svelte, Astro, Angular, and other TypeScript service plugins.

## Commands

Access these via the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`):

| Command ID | Title | Description |
|---|---|---|
| `lumide_typescript.restartLsp` | **TypeScript: Language Server Status** | Show the selected engine and Lumide’s server controls |

## Requirements

- **Node.js**: A Node.js runtime must be installed.
- **Legacy engine**: `npm install -g typescript typescript-language-server`
- **Native engine**: TypeScript 7 or newer (`npm install -g typescript@latest`). Set `typescript-lsp.engine` to `native`.
- **Custom executable**: Set `typescript-lsp.path` to the selected engine’s executable. Reopen the workspace after changing the engine or path.
- Manage Start, Restart, Stop, Disable, and Enable in Lumide’s **LSP & Agents** panel.

TypeScript 7.0 has no stable compiler API. Use legacy when your framework depends on TypeScript service plugins. See the [TypeScript 7 release notes](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/).

| Setting | Default | Description |
|---|---|---|
| `typescript-lsp.engine` | `legacy` | `legacy` (`typescript-language-server`) or `native` (TypeScript 7+) |
| `typescript-lsp.path` | — | Optional executable override |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ by [SoFluffy](https://sofluffy.io).

## Happy Coding 🦊
