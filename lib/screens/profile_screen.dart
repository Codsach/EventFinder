import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import 'saved_events_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsOn = true;
  bool _locationOn = true;
  bool _darkMode = true;

  // Mock user data
  static const _user = (
    name: 'Arjun Mehta',
    email: 'arjun.mehta@gmail.com',
    location: 'Bangalore, KA',
    joined: 'Member since Jan 2024',
    avatarColor: AppTheme.accentPurple,
  );

  static const _stats = [
    (label: 'Attended', value: '12', icon: Icons.event_available_rounded, color: AppTheme.accentCyan),
    (label: 'Saved', value: '3', icon: Icons.bookmark_rounded, color: AppTheme.accentPink),
    (label: 'Reviews', value: '7', icon: Icons.star_rounded, color: Color(0xFFFFD700)),
  ];

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.bgCard,
        content: const Text('Feature coming soon',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                top: -80,
                right: -80,
                child: _Orb(
                    size: 300,
                    color: AppTheme.accentPurple.withOpacity(0.18))),
            Positioned(
                bottom: 100,
                left: -60,
                child: _Orb(
                    size: 220,
                    color: AppTheme.accentCyan.withOpacity(0.1))),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 28),
                    _buildAvatarCard(),
                    const SizedBox(height: 24),
                    _buildStats(),
                    const SizedBox(height: 28),
                    _sectionLabel('Preferences'),
                    const SizedBox(height: 12),
                    _buildToggleMenu(),
                    const SizedBox(height: 28),
                    _sectionLabel('Account'),
                    const SizedBox(height: 12),
                    _buildAccountMenu(context),
                    const SizedBox(height: 28),
                    _buildLogoutButton(context),
                    const SizedBox(height: 16),
                    Text('EventFinder v1.0.0',
                        style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _GlassCircle(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textPrimary, size: 16),
        ),
        const SizedBox(width: 16),
        Text('My Profile',
            style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -1)),
        const Spacer(),
        _GlassCircle(
          onTap: () => _showEditProfile(context),
          child: const Icon(Icons.edit_rounded,
              color: AppTheme.accentCyan, size: 16),
        ),
      ],
    );
  }

  Widget _buildAvatarCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.accentPurple,
                      AppTheme.accentCyan.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: AppTheme.accentPurple.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2)
                  ],
                ),
                child: Center(
                  child: Text(
                    _user.name.split(' ').map((w) => w[0]).take(2).join(),
                    style: GoogleFonts.syne(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00FF9D),
                  border: Border.all(color: AppTheme.bgDeep, width: 2),
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppTheme.bgDeep, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(_user.name,
              style: GoogleFonts.syne(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(_user.email,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 12, color: AppTheme.accentPink),
              const SizedBox(width: 4),
              Text(_user.location,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12.5)),
              const SizedBox(width: 12),
              Container(
                  width: 1,
                  height: 12,
                  color: AppTheme.textMuted),
              const SizedBox(width: 12),
              const Icon(Icons.access_time_rounded,
                  size: 12, color: AppTheme.accentCyan),
              const SizedBox(width: 4),
              Text(_user.joined,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12.5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: _stats.map((s) {
        final isLast = s == _stats.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: s.color.withOpacity(0.08),
                border: Border.all(color: s.color.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(s.icon, color: s.color, size: 22),
                  const SizedBox(height: 8),
                  Text(s.value,
                      style: GoogleFonts.syne(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(s.label,
                      style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildToggleMenu() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _ToggleTile(
            icon: Icons.notifications_outlined,
            color: AppTheme.accentCyan,
            title: 'Push Notifications',
            subtitle: 'Event reminders & updates',
            value: _notificationsOn,
            onChanged: (v) => setState(() => _notificationsOn = v),
            isFirst: true,
          ),
          _Divider(),
          _ToggleTile(
            icon: Icons.location_on_outlined,
            color: AppTheme.accentPink,
            title: 'Location Access',
            subtitle: 'For nearby event suggestions',
            value: _locationOn,
            onChanged: (v) => setState(() => _locationOn = v),
          ),
          _Divider(),
          _ToggleTile(
            icon: Icons.dark_mode_outlined,
            color: AppTheme.accentPurple,
            title: 'Dark Mode',
            subtitle: 'Always-on dark theme',
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountMenu(BuildContext context) {
    final items = [
      (
        icon: Icons.bookmark_border_rounded,
        color: AppTheme.accentPink,
        title: 'Saved Events',
        subtitle: '3 events saved',
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SavedEventsScreen())),
      ),
      (
        icon: Icons.history_rounded,
        color: AppTheme.accentCyan,
        title: 'Event History',
        subtitle: '12 events attended',
        onTap: _showComingSoon,
      ),
      (
        icon: Icons.payment_rounded,
        color: const Color(0xFFFFD700),
        title: 'Payment Methods',
        subtitle: 'Manage cards & UPI',
        onTap: _showComingSoon,
      ),
      (
        icon: Icons.help_outline_rounded,
        color: AppTheme.accentPurple,
        title: 'Help & Support',
        subtitle: 'FAQs, contact us',
        onTap: _showComingSoon,
      ),
    ];

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _MenuTile(
                icon: item.icon,
                color: item.color,
                title: item.title,
                subtitle: item.subtitle,
                onTap: item.onTap,
                isFirst: i == 0,
                isLast: i == items.length - 1,
              ),
              if (i < items.length - 1) _Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmLogout(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppTheme.accentPink.withOpacity(0.1),
          border: Border.all(color: AppTheme.accentPink.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded,
                color: AppTheme.accentPink, size: 18),
            const SizedBox(width: 8),
            Text('LOG OUT',
                style: GoogleFonts.poppins(
                    color: AppTheme.accentPink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _EditProfileSheet(onSave: _showComingSoon),
    );
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard.withOpacity(0.97),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: const Border(top: BorderSide(color: AppTheme.glassBorder)),
            ),
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, 32 + MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(
                        color: AppTheme.textMuted,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 28),
                const Icon(Icons.logout_rounded,
                    color: AppTheme.accentPink, size: 44),
                const SizedBox(height: 16),
                Text('Log Out?',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5)),
                const SizedBox(height: 12),
                Text('You can always log back in.',
                    style: GoogleFonts.inter(
                        color: AppTheme.textSecondary, fontSize: 14)),
                const SizedBox(height: 28),
                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textPrimary,
                        side: const BorderSide(color: AppTheme.glassBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showComingSoon();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentPink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('LOG OUT',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w800, letterSpacing: 1)),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(label,
            style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2)),
      );
}

// ── Sub-widgets ───────────────────────────────────────────────────────────

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isFirst;
  final bool isLast;

  const _ToggleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, isFirst ? 16 : 12, 16, isLast ? 16 : 12),
      child: Row(children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color.withOpacity(0.12)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: color,
          onChanged: onChanged,
        ),
      ]),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _MenuTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            16, isFirst ? 16 : 12, 16, isLast ? 16 : 12),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color.withOpacity(0.12)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppTheme.textMuted, size: 20),
        ]),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: AppTheme.glassBorder,
      );
}

class _EditProfileSheet extends StatelessWidget {
  final VoidCallback onSave;
  const _EditProfileSheet({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard.withOpacity(0.97),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: const Border(
                  top: BorderSide(color: AppTheme.glassBorder)),
            ),
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, 32 + MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 36, height: 4,
                      decoration: BoxDecoration(
                          color: AppTheme.textMuted,
                          borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 24),
                Text('Edit Profile',
                    style: GoogleFonts.poppins(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5)),
                const SizedBox(height: 20),
                _EditField(hint: 'Arjun Mehta', icon: Icons.person_outline_rounded),
                const SizedBox(height: 12),
                _EditField(
                    hint: 'arjun.mehta@gmail.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                _EditField(
                    hint: 'Bangalore, KA',
                    icon: Icons.location_on_outlined),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onSave();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentCyan,
                      foregroundColor: AppTheme.bgDeep,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('SAVE CHANGES',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  const _EditField(
      {required this.hint, required this.icon, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppTheme.glassWhite,
          border: Border.all(color: AppTheme.glassBorder)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(children: [
        Icon(icon, color: AppTheme.accentCyan, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            keyboardType: keyboardType,
            style: const TextStyle(
                color: AppTheme.textPrimary, fontSize: 14.5),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: AppTheme.textMuted, fontSize: 14),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ]),
    );
  }
}

class _GlassCircle extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassCircle({required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppTheme.glassWhite),
              child: Center(child: child),
            ),
          ),
        ),
      );
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                RadialGradient(colors: [color, Colors.transparent])),
      );
}
