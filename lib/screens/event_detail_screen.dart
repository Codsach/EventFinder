import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isSaved = false;
  late AnimationController _heartCtrl;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _heartScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _toggleSave() {
    setState(() => _isSaved = !_isSaved);
    _heartCtrl.forward(from: 0);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final catColor = AppTheme.categoryColor(event.category);
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppTheme.bgDeep,
        body: Stack(
          children: [
            // Background orbs
            Positioned(top: 300, left: -60,
                child: _Orb(size: 240, color: catColor.withOpacity(0.15))),
            Positioned(bottom: 80, right: -40,
                child: _Orb(size: 200, color: AppTheme.accentPurple.withOpacity(0.12))),

            // Scrollable content
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Hero image app bar
                SliverAppBar(
                  expandedHeight: 320,
                  pinned: true,
                  backgroundColor: AppTheme.bgDeep,
                  leading: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _CircleButton(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.textPrimary, size: 16),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ScaleTransition(
                        scale: _heartScale,
                        child: _CircleButton(
                          onTap: _toggleSave,
                          child: Icon(
                            _isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: _isSaved ? AppTheme.accentPink : AppTheme.textPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                      child: _CircleButton(
                        onTap: () => HapticFeedback.selectionClick(),
                        child: const Icon(Icons.share_rounded,
                            color: AppTheme.textPrimary, size: 18),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Hero image
                        Hero(
                          tag: 'event_${event.id}',
                          child: CachedNetworkImage(
                            imageUrl: event.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: AppTheme.bgSurface),
                            errorWidget: (_, __, ___) =>
                                Container(color: AppTheme.bgSurface),
                          ),
                        ),
                        // Heavy gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.4, 1.0],
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                AppTheme.bgDeep,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category + Title
                        _buildTitleSection(event, catColor),
                        const SizedBox(height: 24),

                        // Info grid
                        _buildInfoGrid(event, catColor),
                        const SizedBox(height: 24),

                        // Description
                        _buildDescription(event),
                        const SizedBox(height: 24),

                        // Attendees
                        _buildAttendees(event, catColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom CTA
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _buildBottomCTA(event, catColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(Event event, Color catColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: catColor.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(color: catColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(event.category,
                      style: TextStyle(
                          color: catColor, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.glassWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.glassBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.near_me_rounded,
                      color: AppTheme.accentCyan, size: 12),
                  const SizedBox(width: 4),
                  Text(event.distance,
                      style: const TextStyle(
                          color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          event.title,
          style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(Event event, Color catColor) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _InfoTile(
                icon: Icons.calendar_today_rounded,
                label: 'Date',
                value: event.date,
                color: AppTheme.accentPurple,
              )),
              const SizedBox(width: 12),
              Expanded(child: _InfoTile(
                icon: Icons.schedule_rounded,
                label: 'Time',
                value: event.time,
                color: AppTheme.accentCyan,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _InfoTile(
                icon: Icons.location_on_rounded,
                label: 'Venue',
                value: event.location,
                color: AppTheme.accentPink,
              )),
              const SizedBox(width: 12),
              Expanded(child: _InfoTile(
                icon: Icons.confirmation_number_rounded,
                label: 'Price',
                value: event.price == 0 ? 'FREE' : '₹${event.price.toInt()}',
                color: event.price == 0 ? const Color(0xFF00FF9D) : catColor,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Event event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this Event',
          style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(18),
          child: Text(
            event.description,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14.5,
              height: 1.7,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendees(Event event, Color catColor) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Avatar stack (decorative)
          SizedBox(
            width: 70,
            height: 34,
            child: Stack(
              children: List.generate(3, (i) {
                final colors = [catColor, AppTheme.accentPurple, AppTheme.accentCyan];
                return Positioned(
                  left: i * 20.0,
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors[i].withOpacity(0.3),
                      border: Border.all(color: AppTheme.bgCard, width: 2),
                    ),
                    child: Icon(Icons.person_rounded,
                        color: colors[i], size: 18),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatCount(event.attendees)} people attending',
                  style: const TextStyle(
                      color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 3),
                Text(
                  'Join and be part of the experience',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA(Event event, Color catColor) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20,
              16 + MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: AppTheme.bgDeep.withOpacity(0.85),
            border: const Border(top: BorderSide(color: AppTheme.glassBorder, width: 1)),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(
                    event.price == 0 ? 'FREE' : '₹${event.price.toInt()}',
                    style: TextStyle(
                      color: event.price == 0 ? const Color(0xFF00FF9D) : AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _showTicketBottomSheet(context, event, catColor);
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [catColor, catColor.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: catColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        event.price == 0 ? 'REGISTER FREE' : 'GET TICKETS',
                        style: GoogleFonts.poppins(
                          color: AppTheme.bgDeep,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTicketBottomSheet(BuildContext ctx, Event event, Color catColor) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard.withOpacity(0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: const Border(top: BorderSide(color: AppTheme.glassBorder)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 24),
                Text('Booking Coming Soon!',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                const SizedBox(height: 12),
                Text('Ticket booking integration can be added here.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 15, height: 1.5)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(_),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: catColor,
                      foregroundColor: AppTheme.bgDeep,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text('GOT IT',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile(
      {required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
          const SizedBox(height: 3),
          Text(value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _CircleButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 38, height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.glassWhite,
            ),
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
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
