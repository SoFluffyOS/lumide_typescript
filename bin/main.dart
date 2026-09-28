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

    final configuredEngine = await context.workspace
        .getConfiguration('typescript-lsp.engine') as String?;
    _engine = switch (configuredEngine) {
      'native' => 'native',
      _ => 'legacy',
    };
    final customPath = await context.workspace
        .getConfiguration('typescript-lsp.path') as String?;
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

    if (!await _isServerAvailable(context, _lspCommand)) {
      final installCommand = switch (_engine) {
        'native' => const ['install', '-g', 'typescript@latest'],
        _ => const [
            'install',
            '-g',
            'typescript-language-server',
            'typescript@6'
          ],
      };
      await context.window.showMessage(
        'Installing the $_pluginName language server with npm...',
        title: _pluginName,
      );
      try {
        final result = await context.shell.run('npm', installCommand);
        if (result.exitCode != 0) {
          throw StateError('${result.stderr}\n${result.stdout}'.trim());
        }
        _lspCommand = switch (_engine) {
          'native' => _nativeCommand,
          _ => _legacyCommand,
        };
        if (!await _isServerAvailable(context, _lspCommand)) {
          throw StateError(
            'npm finished, but $_lspCommand is missing or incompatible.',
          );
        }
      } catch (e) {
        final installText = 'npm ${installCommand.join(' ')}';
        await context.window.showMessage(
          'Could not install a usable $_pluginName language server: $e\n\n'
          'Run `$installText` or configure a custom executable.',
          title: _pluginName,
          type: MessageType.warning,
        );
        log('$_logPrefix $_lspCommand unavailable after install attempt');
        return;
      }
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
          'Manage Start, Restart, Stop, Disable, and Enable in Lumide’s LSP & Agents panel.\n'
          'Reopen the workspace after changing the engine or executable path.',
          title: '$_pluginName Language Server',
        );
      },
    );

    log('$_logPrefix $_lspCommand registered for TypeScript and JavaScript');
  }

  Future<bool> _isServerAvailable(
    LumideContext context,
    String command,
  ) async {
    try {
      final version = await context.shell.run(command, const ['--version']);
      if (version.exitCode != 0) return false;
      if (_engine != 'native') return true;
      return RegExp(r'\bVersion\s+(?:[7-9]|\d{2,})\.\d+')
          .hasMatch(version.stdout);
    } catch (error) {
      log('$_logPrefix Could not verify $command: $error');
      return false;
    }
  }

  @override
  Future<void> onDeactivate() async {
    log('$_logPrefix $_pluginName plugin deactivated');
  }
}
