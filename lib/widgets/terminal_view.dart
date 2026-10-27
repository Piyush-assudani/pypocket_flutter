import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/code_execution_model.dart';
import '../services/python_error_explainer.dart';
import '../theme/app_theme.dart';

class TerminalView extends StatelessWidget {
  final CodeExecutionResult? result;
  final bool isLoading;
  final VoidCallback onClear;

  const TerminalView({
    super.key,
    required this.result,
    required this.isLoading,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkTerminalBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Terminal Top Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0C121D),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
              border: Border(bottom: BorderSide(color: AppTheme.borderOf(context))),
            ),
            child: Row(
              children: [
                // Mac style dots
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                const SizedBox(width: 12),

                Text(
                  'TERMINAL OUTPUT',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const Spacer(),

                // Status Indicator
                if (isLoading)
                  Row(
                    children: [
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.pythonYellow),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Executing Python...',
                        style: GoogleFonts.jetBrainsMono(color: AppTheme.pythonYellow, fontSize: 11),
                      ),
                    ],
                  )
                else if (result != null)
                  _buildStatusPill(result!),

                const SizedBox(width: 8),

                // Copy Button
                if (result != null && (result!.stdout.isNotEmpty || (result!.stderr?.isNotEmpty ?? false)))
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 16, color: AppTheme.textSecondary),
                    tooltip: 'Copy Output',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      final content = [
                        if (result!.stdout.isNotEmpty) result!.stdout,
                        if (result!.stderr != null && result!.stderr!.isNotEmpty) result!.stderr!,
                      ].join('\n');
                      Clipboard.setData(ClipboardData(text: content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Output copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                const SizedBox(width: 10),

                // Clear Button
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppTheme.textSecondary),
                  tooltip: 'Clear Console',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onClear,
                ),
              ],
            ),
          ),

          // Terminal Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppTheme.pythonBlue),
              const SizedBox(height: 12),
              Text(
                'Running CPython 3.12 sandbox...',
                style: GoogleFonts.jetBrainsMono(color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    if (result == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              Icon(Icons.terminal_rounded, size: 38, color: AppTheme.border.withValues(alpha: 0.8)),
              const SizedBox(height: 8),
              Text(
                'Press "Run Code" to execute Python script',
                style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 12.5),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Standard Output
        if (result!.stdout.isNotEmpty)
          SelectableText(
            result!.stdout,
            style: GoogleFonts.jetBrainsMono(
              color: const Color(0xFFE2E8F0),
              fontSize: 13,
              height: 1.45,
            ),
          ),

        // Standard Error / Compile Error
        if (result!.stderr != null && result!.stderr!.isNotEmpty) ...[
          if (result!.stdout.isNotEmpty) const SizedBox(height: 10),
          SelectableText(
            result!.stderr!,
            style: GoogleFonts.jetBrainsMono(
              color: const Color(0xFFF87171),
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _buildSmartExplainer(result!.stderr!),
        ],

        // Compile Output
        if (result!.compileOutput != null && result!.compileOutput!.isNotEmpty) ...[
          const SizedBox(height: 10),
          SelectableText(
            result!.compileOutput!,
            style: GoogleFonts.jetBrainsMono(
              color: const Color(0xFFFBBF24),
              fontSize: 12.5,
            ),
          ),
        ],

        // Execution Footer Stats
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            if (result!.executionTime != null)
              _metricChip('Time', '${result!.executionTime}s'),
            if (result!.memory != null)
              _metricChip('RAM', '${result!.memory} KB'),
          ],
        ),
      ],
    );
  }

  Widget _buildSmartExplainer(String stderr) {
    final explained = PythonErrorExplainer.explain(stderr);
    if (explained == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF131524),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.psychology_rounded, size: 16, color: Color(0xFFF87171)),
              ),
              const SizedBox(width: 8),
              Text(
                'PYPOCKET SMART ERROR EXPLAINER',
                style: GoogleFonts.outfit(
                  color: const Color(0xFFF87171),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              const Spacer(),
              if (explained.lineNumber != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFBBF24).withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'Line ${explained.lineNumber}',
                    style: GoogleFonts.jetBrainsMono(
                      color: const Color(0xFFFBBF24),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            explained.summary,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            explained.beginnerExplanation,
            style: GoogleFonts.inter(
              color: const Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF090D16),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, size: 14, color: Color(0xFFFBBF24)),
                    const SizedBox(width: 6),
                    Text(
                      'Suggested Fix:',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFFFBBF24),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  explained.suggestedFix,
                  style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 11.5),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  explained.codeExample,
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xFF6EE7B7),
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF131D2D),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.border, width: 0.8),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.jetBrainsMono(
          color: AppTheme.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusPill(CodeExecutionResult res) {
    final isSuccess = res.isSuccess;
    final color = isSuccess ? AppTheme.accentGreen : AppTheme.errorRed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            res.status,
            style: GoogleFonts.jetBrainsMono(color: color, fontSize: 10.5, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
