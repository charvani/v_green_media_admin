part of '../admin_app.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.enquiries,
    required this.onExport,
    required this.onStatusChanged,
    required this.onView,
    required this.onViewAll,
  });

  final List<Enquiry> enquiries;
  final VoidCallback onExport;
  final void Function(Enquiry, EnquiryStatus) onStatusChanged;
  final ValueChanged<Enquiry> onView;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) => _PageScroll(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PageHeading(
          eyebrow: _formatFullDate(DateTime.now()).toUpperCase(),
          title: 'Good morning, team',
          subtitle: 'Here’s what’s happening with your gifting enquiries.',
          trailing: _exportButton(),
        ),
        const SizedBox(height: 26),
        _StatsGrid(enquiries: enquiries),
        const SizedBox(height: 24),
        _EnquiryListCard(
          enquiries: enquiries.take(5).toList(),
          allEnquiries: enquiries,
          showFilters: false,
          title: 'Recent enquiries',
          subtitle: 'The latest requests from your customers.',
          onStatusChanged: onStatusChanged,
          onView: onView,
          onViewAll: onViewAll,
        ),
      ],
    ),
  );

  Widget _exportButton() => FilledButton.icon(
    onPressed: onExport,
    icon: const Icon(Icons.download_rounded, size: 18),
    label: const Text('Export CSV'),
    style: FilledButton.styleFrom(
      backgroundColor: _forest,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    ),
  );
}
