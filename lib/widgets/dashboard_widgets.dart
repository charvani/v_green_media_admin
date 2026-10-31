part of '../admin_app.dart';

class _PageScroll extends StatelessWidget {
  const _PageScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.sizeOf(context).width < 560 ? 17 : 32,
      vertical: 27,
    ),
    child: child,
  );
}

class _PageHeading extends StatelessWidget {
  const _PageHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final stacked = constraints.maxWidth < 570;
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow,
            style: const TextStyle(
              color: _green,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 7),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: _muted, fontSize: 13)),
        ],
      );
      if (trailing == null) return text;
      if (stacked) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [text, const SizedBox(height: 16), trailing!],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: text),
          trailing!,
        ],
      );
    },
  );
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.enquiries});

  final List<Enquiry> enquiries;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth >= 860
          ? 4
          : constraints.maxWidth >= 540
          ? 2
          : 1;
      final width = (constraints.maxWidth - 14 * (columns - 1)) / columns;
      final newCount = enquiries
          .where((item) => item.status == EnquiryStatus.newEnquiry)
          .length;
      final convertedCount = enquiries
          .where((item) => item.status == EnquiryStatus.converted)
          .length;
      final cards = [
        _StatCard(
          title: 'Total enquiries',
          value: '${enquiries.length}',
          note: 'Across website & app',
          icon: Icons.inbox_outlined,
          tint: const Color(0xFFEAF2EB),
          iconColor: _green,
        ),
        _StatCard(
          title: 'Needs attention',
          value: '$newCount',
          note: 'Waiting for a first reply',
          icon: Icons.mark_email_unread_outlined,
          tint: const Color(0xFFFFF3E4),
          iconColor: const Color(0xFFC28432),
        ),
        _StatCard(
          title: 'In conversation',
          value:
              '${enquiries.where((e) => e.status == EnquiryStatus.contacted).length}',
          note: 'Follow-ups in progress',
          icon: Icons.chat_bubble_outline_rounded,
          tint: const Color(0xFFEBF0FA),
          iconColor: const Color(0xFF607EB8),
        ),
        _StatCard(
          title: 'Converted',
          value: '$convertedCount',
          note: 'Ready to make someone’s day',
          icon: Icons.check_circle_outline_rounded,
          tint: const Color(0xFFE9F4EF),
          iconColor: const Color(0xFF3C9470),
        ),
      ];
      return Wrap(
        spacing: 14,
        runSpacing: 14,
        children: cards
            .map((card) => SizedBox(width: width, child: card))
            .toList(),
      );
    },
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.note,
    required this.icon,
    required this.tint,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String note;
  final IconData icon;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(19),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0xFFE9EDE9)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 17, color: iconColor),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 27,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 9),
        Text(note, style: const TextStyle(color: _muted, fontSize: 11)),
      ],
    ),
  );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = const EdgeInsets.all(18)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: const Color(0xFFE9EDE9)),
    ),
    child: child,
  );
}
