# Changelog

## [Unreleased]

- Add an opt-in TypeScript 7 native LSP engine (`tsc --lsp --stdio`).
- Auto-install the selected server globally with npm when it is missing.
- Register TS and JS extensions through one provider with the correct language IDs.
- Manage servers in Lumide’s LSP & Agents panel; replace the ineffective restart command with status.
- Update the SDK dependency to 1.11.0.

## 1.0.1

- Bump `lumide_api` dependency to `1.1.0`.
- Add `lumide-plugin` topics metadata for better Marketplace discovery.

## 1.0.0

- Initial release of TypeScript support for Lumide IDE.
- Integrated `typescript-language-server` for diagnostics, completions, and navigation.
- Support for JavaScript and TypeScript files.
- Added command to restart the language server.
