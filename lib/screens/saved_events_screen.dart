import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../theme.dart';
import 'event_detail_screen.dart';

class SavedEventsScreen extends StatefulWidget {
  const SavedEventsScreen({super.key});

  @override
  State<SavedEventsScreen> createState() => _SavedEventsScreenState();
}

class _SavedEventsScreenState extends State<SavedEventsScreen> {
  // In a real app this comes from SharedPreferences / a local DB.
  // Seeded with sample data for the assignment demo.
  final List<Event> _events = [
    const Event(
      id: '1',
      title: 'Neon Nights Music Festival',
      category: 'Music',
      date: 'Sat, May 10 2025',
      time: '7:00 PM',
      location: 'Bangalore Palace Grounds',
      imageUrl:
          'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800',
      distance: '2.4 km',
      description:
          'An electrifying night of live music featuring top indie and electronic artists.',
      price: 1299,
      attendees: 3200,
    ),
    const Event(
      id: '3',
      title: 'TechSpark Summit 2025',
      category: 'Tech',
      date: 'Fri, May 16 2025',
      time: '9:00 AM',
      location: 'NIMHANS Convention Centre',
      imageUrl:
          'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
      distance: '4.7 km',
      description:
          'Join 5000+ developers, designers, and founders for a full-day tech conference.',
      price: 499,
      attendees: 5000,
    ),
    const Event(
      id: '5',
      title: 'Indie Art Fair: Canvas & Craft',
      category: 'Art',
      date: 'Sat, May 24 2025',
      time: '11:00 AM',
      location: '1 Shanthala St, Indiranagar',
      imageUrl:
          'https://images.unsplash.com/photo-1578926078693-59bac7a9bf0a?w=800',
      distance: '5.3 km',
      description:
          'Explore a curated collection of paintings, sculptures, and photography.',
      price: 0,
      attendees: 800,
    ),
  ];

  void _removeEvent(int index, BuildContext ctx) {
    final removed = _events[index];
    HapticFeedback.lightImpact();
    setState(() => _events.removeAt(index));

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.bgCard,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text('Removed "${removed.title}"',
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppTheme.accentCyan,
          onPressed: () => setState(() => _events.insert(index, removed)),
        ),
      ),
    );
  }

  void _confirmClearAll() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ClearAllSheet(
        onConfirm: () {
          setState(() => _events.clear());
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppTheme.bgDeep,
        body: Stack(
          children: [
            Positioned(
                top: -60,
                right: -60,
                child: _Orb(
                    size: 260,
                    color: AppTheme.accentPink.withOpacity(0.14))),
            Positioned(
                bottom: 120,
                left: -60,
                child: _Orb(
                    size: 200,
                    color: AppTheme.accentCyan.withOpacity(0.10))),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(
                    count: _events.length,
                    showClear: _events.isNotEmpty,
                    onClear: _confirmClearAll,
                  ),
                  Expanded(
                    child: _events.isEmpty
                        ? const _EmptyState()
                        : _buildList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      physics: const BouncingScrollPhysics(),
      itemCount: _events.length,
      itemBuilder: (ctx, i) {
        final event = _events[i];
        final catColor = AppTheme.categoryColor(event.category);

        return Dismissible(
          key: ValueKey(event.id),
          direction: DismissDirection.endToStart,
          background: _SwipeBg(),
          onDismissed: (_) => _removeEvent(i, ctx),
          child: GestureDetector(
            onTap: () => Navigator.push(
              ctx,
              MaterialPageRoute(
                  builder: (_) => EventDetailScreen(event: event)),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.glassBorder, width: 1.2),
                color: AppTheme.bgCard,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(24)),
                    child: CachedNetworkImage(
                      imageUrl: event.imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                          width: 110,
                          height: 110,
                          color: AppTheme.bgSurface),
                      errorWidget: (_, __, ___) => Container(
                          width: 110,
                          height: 110,
                          color: AppTheme.bgSurface,
                          child: const Icon(Icons.broken_image_outlined,
                              color: AppTheme.textMuted)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: catColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: catColor.withOpacity(0.3)),
                            ),
                            child: Text(event.category.toUpperCase(),
                                style: GoogleFonts.inter(
                                    color: catColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5)),
                          ),
                          const SizedBox(height: 8),
                          Text(event.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  color: AppTheme.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          _IconRow(
                              icon: Icons.calendar_today_rounded,
                              color: AppTheme.accentPurple,
                              text: '${event.date}'),
                          const SizedBox(height: 4),
                          _IconRow(
                              icon: Icons.location_on_rounded,
                              color: AppTheme.accentPink,
                              text: event.location),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final int count;
  final bool showClear;
  final VoidCallback onClear;
  const _Header(
      {required this.count,
      required this.showClear,
      required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          _GlassCircle(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppTheme.textPrimary, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Saved Events',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1)),
                Text('$count events bookmarked',
                    style: GoogleFonts.inter(
                        color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (showClear)
            _GlassCircle(
              onTap: onClear,
              child: const Icon(Icons.delete_sweep_rounded,
                  color: AppTheme.accentPink, size: 18),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentPink.withOpacity(0.1),
              border: Border.all(
                  color: AppTheme.accentPink.withOpacity(0.2)),
            ),
            child: const Icon(Icons.bookmark_border_rounded,
                color: AppTheme.accentPink, size: 38),
          ),
          const SizedBox(height: 20),
          Text('No saved events yet',
              style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Events you save will appear here.\nTap the heart on any event to save it.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeBg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [
          AppTheme.accentPink.withOpacity(0.05),
          AppTheme.accentPink.withOpacity(0.3),
        ]),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_outline_rounded,
              color: AppTheme.accentPink, size: 24),
          const SizedBox(height: 4),
          Text('Remove',
              style: TextStyle(
                  color: AppTheme.accentPink,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ClearAllSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  const _ClearAllSheet({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.bgCard.withOpacity(0.95),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(28)),
            border: const Border(
                top: BorderSide(color: AppTheme.glassBorder)),
          ),
          padding: EdgeInsets.fromLTRB(
              24, 16, 24, 40 + MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppTheme.textMuted,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              const Icon(Icons.delete_sweep_rounded,
                  color: AppTheme.accentPink, size: 44),
              const SizedBox(height: 16),
              Text('Clear All Saved?',
                  style: GoogleFonts.syne(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('This will remove all bookmarked events.',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 14)),
              const SizedBox(height: 28),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: const BorderSide(
                          color: AppTheme.glassBorder),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentPink,
                      foregroundColor: Colors.white,
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Clear All',
                        style:
                            TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _IconRow(
      {required this.icon, required this.color, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 11, color: color),
      const SizedBox(width: 4),
      Expanded(
          child: Text(text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 11.5))),
    ]);
  }
}

class _GlassCircle extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassCircle({required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppTheme.glassWhite),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                RadialGradient(colors: [color, Colors.transparent])),
      );
}
