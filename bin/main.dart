/// TypeScript and JavaScript language support plugin for Lumide IDE.
///
/// Registers either TypeScript 7's native LSP or typescript-language-server.
library;

import 'package:lumide_api/lumide_api.dart';

void main() => TypeScriptPlugin().run();

class TypeScriptPlugin extends LumidePlugin {
  static const _logPrefix = '💠';
  static const _legacyCommand = 'typescript-language-server';
  static const _nativeCommand = 'tsc';
  static const _providerId = 'typescript-lsp';
  static const _languageId = 'typescript';
  static const _fileExtensions = [
    '.ts',
    '.tsx',
    '.mts',
    '.cts',
    '.js',
    '.jsx',
    '.mjs',
    '.cjs',
  ];
  static const _extensionLanguageMap = {
    '.ts': 'typescript',
    '.tsx': 'typescript',
    '.mts': 'typescript',
    '.cts': 'typescript',
    '.js': 'javascript',
    '.jsx': 'javascript',
    '.mjs': 'javascript',
    '.cjs': 'javascript',
  };

  static const _restartCommandId = 'lumide_typescript.restartLsp';
  static const _pluginName = 'TypeScript';

  late String _engine;
  late String _lspCommand;
  late List<String> _lspArgs;

  @override
  Future<void> onActivate(LumideContext context) async {
    log('$_logPrefix $_pluginName plugin activated');

    final configuredEngine =
        await context.workspace.getConfiguration('typescript-lsp.engine')
            as String?;
    _engine = switch (configuredEngine) {
      'native' => 'native',
      _ => 'legacy',
    };
    final customPath =
        await context.workspace.getConfiguration('typescript-lsp.path')
            as String?;
    final configuredPath = customPath?.trim();
    _lspCommand = configuredPath ?? '';
    if (_lspCommand.isEmpty) {
      _lspCommand = switch (_engine) {
        'native' => _nativeCommand,
        _ => _legacyCommand,
      };
    }
    _lspArgs = switch (_engine) {
      'native' => const ['--lsp', '--stdio'],
      _ => const ['--stdio'],
    };

    try {
      final version = await context.shell.run(_lspCommand, const ['--version']);
      if (version.exitCode != 0) throw StateError('Non-zero exit code');
      if (_engine == 'native' &&
          !RegExp(
            r'\bVersion\s+(?:[7-9]|\d{2,})\.\d+',
          ).hasMatch(version.stdout)) {
        throw StateError('TypeScript 7 or newer is required for native LSP.');
      }
    } catch (e) {
      final installCommand = switch (_engine) {
        'native' => 'npm install -g typescript@latest',
        _ => 'npm install -g typescript-language-server typescript',
      };
      await context.window.showMessage(
        'Could not use $_lspCommand for $_pluginName language support: $e\n\n'
        'Install the selected engine with: $installCommand',
        title: _pluginName,
        type: MessageType.warning,
      );
      log('$_logPrefix $_lspCommand unavailable, aborting');
      return;
    }

    await context.languages.registerLanguageServer(
      id: _providerId,
      languageId: _languageId,
      displayName: switch (_engine) {
        'native' => 'TypeScript 7 (Go)',
        _ => 'TypeScript Language Server',
      },
      fileExtensions: _fileExtensions,
      extensionLanguageMap: _extensionLanguageMap,
      command: _lspCommand,
      args: _lspArgs,
    );

    await context.commands.registerCommand(
      id: _restartCommandId,
      title: '$_pluginName: Language Server Status',
      category: _pluginName,
      callback: ([args]) async {
        await context.window.showMessage(
          '$_pluginName server: ${switch (_engine) {
            'native' => 'TypeScript 7 (Go)',
            _ => 'typescript-language-server',
          }}\n\n'
          'Manage Start, Restart, Stop, and Disable in Lumide’s LSP & Agents panel.\n'
          'Reopen the workspace after changing the engine or executable path.',
          title: '$_pluginName Language Server',
        );
      },
    );

    log('$_logPrefix $_lspCommand registered for TypeScript and JavaScript');
  }

  @override
  Future<void> onDeactivate() async {
    log('$_logPrefix $_pluginName plugin deactivated');
  }
}
