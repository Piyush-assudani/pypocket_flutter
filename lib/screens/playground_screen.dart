import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/code_execution_model.dart';
import '../models/snippet_model.dart';
import '../services/python_runner_service.dart';
import '../services/storage_service.dart';
import '../data/sample_codes_data.dart';
import '../theme/app_theme.dart';
import '../widgets/python_editor.dart';
import '../widgets/terminal_view.dart';
import '../widgets/xp_badge.dart';

class PlaygroundScreen extends StatefulWidget {
  final String? initialCode;

  const PlaygroundScreen({super.key, this.initialCode});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  final PythonRunnerService _runnerService = PythonRunnerService();
  late TextEditingController _codeController;
  final TextEditingController _stdinController = TextEditingController();

  CodeExecutionResult? _executionResult;
  bool _isLoading = false;
  bool _showStdin = false;
  int _activeTabIndex = 0; // 0 = Editor, 1 = Terminal

  @override
  void initState() {
    super.initState();
    final savedCode = StorageService.getLastPlaygroundCode();
    _codeController = TextEditingController(
      text: widget.initialCode ?? savedCode ?? SampleCodesData.samples.first.code,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _stdinController.dispose();
    super.dispose();
  }

  Future<void> _runCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some Python code to execute')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _activeTabIndex = 1; // Switch to terminal on run
    });

    // Save code to local state
    await StorageService.savePlaygroundCode(_codeController.text);

    final res = await _runnerService.executePython(
      sourceCode: _codeController.text,
      stdin: _stdinController.text,
    );

    if (mounted) {
      setState(() {
        _executionResult = res;
        _isLoading = false;
      });

      // Award XP for running code successfully
      if (res.isSuccess) {
        await StorageService.addXp(5);
      }
    }
  }

  void _loadSample(CodeSample sample) {
    setState(() {
      _codeController.text = sample.code;
      _activeTabIndex = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded "${sample.title}"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSaveSnippetDialog() {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceOf(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppTheme.borderOf(context)),
        ),
        title: Text(
          'Save to My Snippets',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.textPrimaryOf(context)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Save your Python script so you can reload or edit it anytime.',
              style: GoogleFonts.inter(color: AppTheme.textSecondaryOf(context), fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: titleController,
              autofocus: true,
              style: GoogleFonts.inter(color: AppTheme.textPrimaryOf(context)),
              decoration: const InputDecoration(
                labelText: 'Snippet Title',
                hintText: 'e.g. Binary Search Tree / API Script',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                final snippet = CodeSnippet(
                  id: const Uuid().v4(),
                  title: title,
                  code: _codeController.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                await StorageService.saveSnippet(snippet);
                if (ctx.mounted) Navigator.pop(ctx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Saved to your snippet library!'),
                      backgroundColor: AppTheme.accentGreen,
                    ),
                  );
                }
              }
            },
            child: const Text('Save Snippet'),
          ),
        ],
      ),
    );
  }

  void _showMySnippetsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final currentSnippets = StorageService.getSnippets();
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bookmark_rounded, color: AppTheme.pythonYellow, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'My Saved Snippets (${currentSnippets.length})',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryOf(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (currentSnippets.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          'No saved snippets yet. Click "Save" to save your custom code!',
                          style: GoogleFonts.inter(color: AppTheme.textMutedOf(context)),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: currentSnippets.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = currentSnippets[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: AppTheme.cardOf(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderOf(context)),
                            ),
                            child: ListTile(
                              title: Text(
                                item.title,
                                style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppTheme.textPrimaryOf(context)),
                              ),
                              subtitle: Text(
                                '${item.code.split('\n').length} lines of code',
                                style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondaryOf(context)),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.errorRed),
                                onPressed: () async {
                                  await StorageService.deleteSnippet(item.id);
                                  setModalState(() {});
                                },
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  _codeController.text = item.code;
                                  _activeTabIndex = 0;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSamplePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_stories_rounded, color: AppTheme.pythonYellow, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Load Python Algorithm / Snippet',
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryOf(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: SampleCodesData.samples.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = SampleCodesData.samples[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardOf(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderOf(context)),
                      ),
                      child: ListTile(
                        title: Text(
                          item.title,
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppTheme.textPrimaryOf(context)),
                        ),
                        subtitle: Text(
                          item.description,
                          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondaryOf(context)),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.pythonBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.category,
                            style: GoogleFonts.jetBrainsMono(
                              color: AppTheme.pythonBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _loadSample(item);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = StorageService.getUserProfile();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.pythonBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.terminal_rounded, color: AppTheme.pythonYellow, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'PyPocket IDE',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ],
        ),
        actions: [
          // Theme Quick Switch
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 20),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
              StorageService.setThemeMode(newMode);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: XpBadge(xp: profile.xp, streakDays: profile.streakDays),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Controls Toolbar (Responsive, zero overflow on any screen width)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 560;
                  if (isCompact) {
                    return Column(
                      children: [
                        // Row 1: Primary Run CTA & Code/Terminal Switch
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _runCode,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.play_arrow_rounded, size: 18),
                              label: Text(
                                _isLoading ? 'Running...' : 'Run Code',
                                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13.5),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 1,
                              ),
                            ),
                            const Spacer(),
                            // Editor / Terminal Segmented Switch
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.cardOf(context),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.borderOf(context)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _tabButton(0, 'Code', Icons.code_rounded),
                                  _tabButton(1, 'Terminal', Icons.terminal_rounded),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Row 2: Secondary Utilities (Samples, Save, Snippets, Stdin)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: _showSamplePicker,
                                icon: const Icon(Icons.folder_open_rounded, size: 14),
                                label: Text('Samples', style: GoogleFonts.inter(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: _showSaveSnippetDialog,
                                icon: const Icon(Icons.save_outlined, size: 14),
                                label: Text('Save', style: GoogleFonts.inter(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: _showMySnippetsModal,
                                icon: const Icon(Icons.collections_bookmark_outlined, size: 14),
                                label: Text('Snippets', style: GoogleFonts.inter(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => setState(() => _showStdin = !_showStdin),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: _showStdin
                                        ? AppTheme.pythonYellow.withValues(alpha: 0.15)
                                        : AppTheme.surfaceOf(context),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _showStdin
                                          ? AppTheme.pythonYellow
                                          : AppTheme.borderOf(context),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.input_rounded,
                                        size: 14,
                                        color: _showStdin
                                            ? AppTheme.pythonYellow
                                            : AppTheme.textSecondaryOf(context),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'stdin',
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: _showStdin
                                              ? AppTheme.pythonYellow
                                              : AppTheme.textSecondaryOf(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  // Wide View (Desktop / Tablet)
                  return Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _runCode,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.play_arrow_rounded, size: 18),
                        label: Text(_isLoading ? 'Running...' : 'Run Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _showSamplePicker,
                        icon: const Icon(Icons.folder_open_rounded, size: 14),
                        label: const Text('Samples'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: _showSaveSnippetDialog,
                        tooltip: 'Save Snippet',
                        icon: const Icon(Icons.save_outlined, size: 18),
                      ),
                      IconButton(
                        onPressed: _showMySnippetsModal,
                        tooltip: 'My Saved Library',
                        icon: const Icon(Icons.collections_bookmark_outlined, size: 18),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _showStdin = !_showStdin),
                        tooltip: 'Standard Input (stdin)',
                        icon: Icon(
                          Icons.input_rounded,
                          color: _showStdin ? AppTheme.pythonYellow : AppTheme.textMutedOf(context),
                          size: 18,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.cardOf(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderOf(context)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _tabButton(0, 'Code', Icons.code_rounded),
                            _tabButton(1, 'Terminal', Icons.terminal_rounded),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),

              // Collapsible STDIN field
              if (_showStdin) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.cardOf(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.pythonYellow.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.input_rounded, size: 18, color: AppTheme.pythonYellow),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _stdinController,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: AppTheme.textPrimaryOf(context),
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Enter stdin for input() (separated by newlines)',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Main Workspace View (Editor or Terminal)
              Expanded(
                child: IndexedStack(
                  index: _activeTabIndex,
                  children: [
                    PythonEditor(
                      controller: _codeController,
                      onRun: _runCode,
                    ),
                    TerminalView(
                      result: _executionResult,
                      isLoading: _isLoading,
                      onClear: () {
                        setState(() {
                          _executionResult = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(int index, String label, IconData icon) {
    final isSelected = _activeTabIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.pythonBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppTheme.textSecondaryOf(context),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? Colors.white : AppTheme.textSecondaryOf(context),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
