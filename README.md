# lumide_typescript

[![pub package](https://img.shields.io/pub/v/lumide_typescript.svg)](https://pub.dev/packages/lumide_typescript) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Powered by SoFluffy](https://img.shields.io/badge/Powered%20by-SoFluffy-orange)](https://sofluffy.io)

The official TypeScript and JavaScript extension for [Lumide IDE](https://lumide.dev).

`lumide_typescript` provides robust, high-performance language support for TypeScript and JavaScript in Lumide using the `typescript-language-server`.

## Features

### 🛠 Modern Web Support
- **IntelliSense**: Intelligent code completions, signatures, and documentation hovers for TS and JS.
- **Diagnostics**: Real-time syntax and semantic errors highlighting.
- **Navigation**: Instant go-to-definition, find references, and symbol search.
- **Project Aware**: Understands `tsconfig.json`, `package.json`, and npm dependency graphs.

### ⚡ Unified Server
- **Dual Support**: Single server handles both `.ts` and `.js` files concurrently for maximum efficiency.
- **Node.js Integration**: Directly interacts with the latest language server for optimal performance.

## Commands

Access these via the Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`):

| Command ID | Title | Description |
|---|---|---|
| `lumide_typescript.restartLsp` | **TypeScript: Restart Language Server** | Restart the `typescript-language-server` process |

## Requirements

- **Node.js**: A Node.js runtime must be installed.
- **TypeScript & Server**: The TypeScript compiler and language server.
    - **Installation**: `npm install -g typescript typescript-language-server`
    - Ensure `typescript-language-server` is in your system `PATH`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built with ❤️ by [SoFluffy](https://sofluffy.io).

## Happy Coding 🦊
