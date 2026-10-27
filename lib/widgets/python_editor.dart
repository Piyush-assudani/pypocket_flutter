import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class PythonEditor extends StatefulWidget {
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onRun;

  const PythonEditor({
    super.key,
    required this.controller,
    this.readOnly = false,
    this.onRun,
  });

  @override
  State<PythonEditor> createState() => _PythonEditorState();
}

class _PythonEditorState extends State<PythonEditor> {
  double _fontSize = 13.5;
  int _lineCount = 1;

  final List<String> _quickSymbols = [
    '    ', // 4-space Tab
    ':',
    '(',
    ')',
    '[',
    ']',
    '{',
    '}',
    '=',
    '==',
    '"',
    "'",
    '+',
    '-',
    '*',
    '/',
    '%',
    '_',
    ',',
    '#',
    '->',
  ];

  @override
  void initState() {
    super.initState();
    _updateLineCount();
    widget.controller.addListener(_updateLineCount);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateLineCount);
    super.dispose();
  }

  void _updateLineCount() {
    final count = '\n'.allMatches(widget.controller.text).length + 1;
    if (count != _lineCount && mounted) {
      setState(() {
        _lineCount = count;
      });
    }
  }

  void _insertSymbol(String sym) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    final start = selection.start >= 0 ? selection.start : text.length;
    final end = selection.end >= 0 ? selection.end : text.length;

    final newText = text.replaceRange(start, end, sym);
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + sym.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1424),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF11192C),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
              border: Border(bottom: BorderSide(color: AppTheme.borderOf(context))),
            ),
            child: Row(
              children: [
                const Icon(Icons.code_rounded, size: 16, color: AppTheme.pythonYellow),
                const SizedBox(width: 8),
                Text(
                  'main.py',
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),

                // Font size controls
                IconButton(
                  icon: const Icon(Icons.text_decrease_rounded, size: 15, color: AppTheme.textSecondary),
                  tooltip: 'Decrease Font',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    if (_fontSize > 11) setState(() => _fontSize -= 1.0);
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  '${_fontSize.toInt()}pt',
                  style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 11),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.text_increase_rounded, size: 15, color: AppTheme.textSecondary),
                  tooltip: 'Increase Font',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    if (_fontSize < 20) setState(() => _fontSize += 1.0);
                  },
                ),
                const SizedBox(width: 12),

                // Clear Code
                IconButton(
                  icon: const Icon(Icons.backspace_outlined, size: 15, color: AppTheme.textMuted),
                  tooltip: 'Clear Editor',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    widget.controller.clear();
                  },
                ),
              ],
            ),
          ),

          // Code Text Area with Line Numbers
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Line Number Gutter
                Container(
                  width: 38,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF090E1A),
                    border: Border(right: BorderSide(color: AppTheme.border, width: 0.8)),
                  ),
                  child: ListView.builder(
                    itemCount: _lineCount,
                    itemBuilder: (context, idx) {
                      return Text(
                        '${idx + 1}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.textMuted.withValues(alpha: 0.6),
                          fontSize: _fontSize,
                          height: 1.45,
                        ),
                      );
                    },
                  ),
                ),

                // Input Editor Field
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: widget.controller,
                      readOnly: widget.readOnly,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: _fontSize,
                        height: 1.45,
                        color: const Color(0xFFE2E8F0),
                      ),
                      cursorColor: AppTheme.pythonYellow,
                      cursorWidth: 2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Quick Symbol Bar for Mobile/Tablet convenience
          Container(
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFF0A0F1D),
              border: Border(top: BorderSide(color: AppTheme.border, width: 0.8)),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(13),
                bottomRight: Radius.circular(13),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _quickSymbols.length,
              itemBuilder: (context, index) {
                final sym = _quickSymbols[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                  child: Material(
                    color: const Color(0xFF162035),
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => _insertSymbol(sym),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                        alignment: Alignment.center,
                        child: Text(
                          sym == '    ' ? 'Tab ⇥' : sym,
                          style: GoogleFonts.jetBrainsMono(
                            color: AppTheme.pythonYellow,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
