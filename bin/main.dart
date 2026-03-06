/// TypeScript and JavaScript language support plugin for Lumide IDE.
///
/// Registers typescript-language-server for TS/JS files.
library;

import 'package:lumide_api/lumide_api.dart';

void main() => TypeScriptPlugin().run();

class TypeScriptPlugin extends LumidePlugin {
  static const _logPrefix = '💠';
  static const _defaultLspCommand = 'typescript-language-server';

  static const _tsPluginId = 'typescript-lsp';
  static const _tsLanguageId = 'typescript';
  static const _tsFileExtensions = ['.ts', '.tsx'];

  static const _jsPluginId = 'javascript-lsp';
  static const _jsLanguageId = 'javascript';
  static const _jsFileExtensions = ['.js', '.jsx', '.mjs', '.cjs'];

  static const _restartCommandId = 'lumide_typescript.restartLsp';
  static const _pluginName = 'TypeScript';
  static const _lspArgs = ['--stdio'];

  String _lspCommand = _defaultLspCommand;

  @override
  Future<void> onActivate(LumideContext context) async {
    log('$_logPrefix $_pluginName plugin activated');

    final customPath = await context.workspace
        .getConfiguration('$_tsPluginId.path') as String?;
    if (customPath != null && customPath.trim().isNotEmpty) {
      _lspCommand = customPath.trim();
    }

    try {
      final res = await context.shell.run(_lspCommand, ['--version']);
      if (res.exitCode != 0) throw Exception('Non-zero exit code');
    } catch (e) {
      await context.window.showMessage(
        '$_lspCommand is not installed. Please install it to enable $_pluginName/JavaScript language support.\n\n'
        'Run: npm install -g typescript-language-server typescript',
        title: _pluginName,
        type: MessageType.warning,
      );
      log('$_logPrefix $_lspCommand not found, aborting');
      return;
    }

    // Register for TypeScript files
    await context.languages.registerLanguageServer(
      id: _tsPluginId,
      languageId: _tsLanguageId,
      fileExtensions: _tsFileExtensions,
      command: _lspCommand,
      args: _lspArgs,
    );

    // Register for JavaScript files (same server)
    await context.languages.registerLanguageServer(
      id: _jsPluginId,
      languageId: _jsLanguageId,
      fileExtensions: _jsFileExtensions,
      command: _lspCommand,
      args: _lspArgs,
    );

    await context.commands.registerCommand(
      id: _restartCommandId,
      title: '$_pluginName: Restart Language Server',
      category: _pluginName,
      callback: ([args]) async {
        await context.languages.registerLanguageServer(
          id: _tsPluginId,
          languageId: _tsLanguageId,
          fileExtensions: _tsFileExtensions,
          command: _lspCommand,
          args: _lspArgs,
        );
        await context.languages.registerLanguageServer(
          id: _jsPluginId,
          languageId: _jsLanguageId,
          fileExtensions: _jsFileExtensions,
          command: _lspCommand,
          args: _lspArgs,
        );
        await context.window.showMessage(
          '$_pluginName language server restarted',
          title: _pluginName,
        );
      },
    );

    log('$_logPrefix $_lspCommand registered for .ts/.js files');
  }

  @override
  Future<void> onDeactivate() async {
    log('$_logPrefix $_pluginName plugin deactivated');
  }
}
