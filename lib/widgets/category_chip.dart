import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';

class CategoryChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.categoryColor(widget.label);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: widget.isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.7)],
                  )
                : (_isHovered 
                    ? LinearGradient(
                        colors: [AppTheme.bgCard, AppTheme.glassWhite],
                      )
                    : null),
            color: widget.isSelected ? null : AppTheme.bgCard,
            border: Border.all(
              color: widget.isSelected 
                ? color.withValues(alpha: 0.5)
                : (_isHovered ? AppTheme.accentCyan.withValues(alpha: 0.3) : AppTheme.glassBorder),
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    )
                  ]
                : (_isHovered ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ] : []),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              color: widget.isSelected 
                ? AppTheme.bgDeep 
                : (_isHovered ? AppTheme.textPrimary : AppTheme.textSecondary),
              fontSize: 14,
              fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        )
        .animate(target: widget.isSelected ? 1 : 0)
        .scale(
          begin: const Offset(1, 1), 
          end: const Offset(1.05, 1.05), 
          duration: 200.ms, 
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }
}
