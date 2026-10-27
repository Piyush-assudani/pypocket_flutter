import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExecutiveAvatarInfo {
  final String id;
  final String title;
  final String subtitle;
  final String glyph;
  final IconData icon;
  final List<Color> gradient;
  final Color accentColor;

  const ExecutiveAvatarInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.glyph,
    required this.icon,
    required this.gradient,
    required this.accentColor,
  });
}

class ExecutiveAvatars {
  static const Map<String, ExecutiveAvatarInfo> catalog = {
    'python_architect': ExecutiveAvatarInfo(
      id: 'python_architect',
      title: 'Python Architect',
      subtitle: 'Core systems & clean architecture',
      glyph: 'PY',
      icon: Icons.architecture_rounded,
      gradient: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
      accentColor: Color(0xFF60A5FA),
    ),
    'neural_ai': ExecutiveAvatarInfo(
      id: 'neural_ai',
      title: 'AI Research Engineer',
      subtitle: 'Neural networks, PyTorch & LLMs',
      glyph: 'AI',
      icon: Icons.psychology_rounded,
      gradient: [Color(0xFF4C1D95), Color(0xFF8B5CF6)],
      accentColor: Color(0xFFA78BFA),
    ),
    'cyber_architect': ExecutiveAvatarInfo(
      id: 'cyber_architect',
      title: 'Cyber Systems Lead',
      subtitle: 'High-speed automation & security',
      glyph: 'SEC',
      icon: Icons.security_rounded,
      gradient: [Color(0xFF064E3B), Color(0xFF10B981)],
      accentColor: Color(0xFF34D399),
    ),
    'algo_scientist': ExecutiveAvatarInfo(
      id: 'algo_scientist',
      title: 'Algorithm Specialist',
      subtitle: 'Data structures & Big-O optimization',
      glyph: 'O(1)',
      icon: Icons.insights_rounded,
      gradient: [Color(0xFF78350F), Color(0xFFD97706)],
      accentColor: Color(0xFFFBBF24),
    ),
    'fullstack_engineer': ExecutiveAvatarInfo(
      id: 'fullstack_engineer',
      title: 'Full-Stack Pythoneer',
      subtitle: 'FastAPI, Django & microservices',
      glyph: 'API',
      icon: Icons.dns_rounded,
      gradient: [Color(0xFF0F172A), Color(0xFF2563EB)],
      accentColor: Color(0xFF38BDF8),
    ),
    'data_quantitative': ExecutiveAvatarInfo(
      id: 'data_quantitative',
      title: 'Quantitative Scientist',
      subtitle: 'NumPy, Pandas & financial analytics',
      glyph: 'DS',
      icon: Icons.query_stats_rounded,
      gradient: [Color(0xFF134E4A), Color(0xFF0D9488)],
      accentColor: Color(0xFF2DD4BF),
    ),
  };

  static ExecutiveAvatarInfo get(String id) {
    return catalog[id] ?? catalog['python_architect']!;
  }
}

class ExecutiveAvatarWidget extends StatelessWidget {
  final String avatarId;
  final double size;
  final bool showBadge;

  const ExecutiveAvatarWidget({
    super.key,
    required this.avatarId,
    this.size = 54,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = ExecutiveAvatars.get(avatarId);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: avatar.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: avatar.accentColor.withValues(alpha: 0.35),
            blurRadius: size * 0.25,
            offset: Offset(0, size * 0.08),
          ),
        ],
        border: Border.all(
          color: avatar.accentColor.withValues(alpha: 0.6),
          width: size * 0.035,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              avatar.icon,
              size: size * 0.42,
              color: Colors.white,
            ),
            if (showBadge && size >= 48) ...[
              const SizedBox(height: 1),
              Text(
                avatar.glyph,
                style: GoogleFonts.jetBrainsMono(
                  color: avatar.accentColor,
                  fontSize: size * 0.16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
