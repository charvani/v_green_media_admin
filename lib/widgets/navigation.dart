part of '../admin_app.dart';

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.selectedEnquiries,
    required this.onSelect,
    required this.onLogout,
  });

  final bool selectedEnquiries;
  final ValueChanged<bool> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => Container(
    color: _forest,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(23, 26, 16, 36),
          child: BrandMark(dark: true),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 16, 12),
          child: Text(
            'WORKSPACE',
            style: TextStyle(
              color: Color(0xFF9AB3A2),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ),
        _SidebarItem(
          icon: Icons.grid_view_rounded,
          label: 'Overview',
          selected: !selectedEnquiries,
          onTap: () => onSelect(false),
        ),
        _SidebarItem(
          icon: Icons.inbox_outlined,
          label: 'Enquiries',
          selected: selectedEnquiries,
          badge: '8',
          onTap: () => onSelect(true),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF214936),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF315943)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.eco_outlined, color: Color(0xFFB7D5B6), size: 19),
              SizedBox(height: 10),
              Text(
                'Thoughtful gifting,\nmade easy.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Your Tribe Green workspace',
                style: TextStyle(color: Color(0xFFB8C9BC), fontSize: 10),
              ),
            ],
          ),
        ),
        _SidebarItem(
          icon: Icons.logout_rounded,
          label: 'Log out',
          onTap: onLogout,
        ),
        const SizedBox(height: 12),
      ],
    ),
  );
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final String? badge;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
    child: Material(
      color: selected ? const Color(0xFF2A523C) : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: SizedBox(
          height: 45,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(
                icon,
                size: 19,
                color: selected ? Colors.white : const Color(0xFFB6C7BB),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFFD4DED7),
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  margin: const EdgeInsets.only(right: 11),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF41664E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.dark = false, this.compact = false});

  final bool dark;
  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: compact ? 31 : 35,
        height: compact ? 31 : 35,
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF315A41) : const Color(0xFFE9F2EA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.eco_rounded,
          color: dark ? const Color(0xFFB8D7B5) : _forest,
          size: 21,
        ),
      ),
      const SizedBox(width: 10),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'tribe green',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: dark ? Colors.white : _forest,
                fontSize: compact ? 15 : 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
            if (!compact)
              Text(
                'ADMIN WORKSPACE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: dark ? const Color(0xFFABC0B0) : _muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
