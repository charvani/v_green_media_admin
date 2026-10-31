part of '../admin_app.dart';

class EnquiriesScreen extends StatelessWidget {
  const EnquiriesScreen({
    super.key,
    required this.enquiries,
    required this.allEnquiries,
    required this.searchQuery,
    required this.statusFilter,
    required this.sourceFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    required this.onSourceFilterChanged,
    required this.onStatusChanged,
    required this.onView,
    required this.onExport,
  });

  final List<Enquiry> enquiries;
  final List<Enquiry> allEnquiries;
  final String searchQuery;
  final String statusFilter;
  final String sourceFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusFilterChanged;
  final ValueChanged<String> onSourceFilterChanged;
  final void Function(Enquiry, EnquiryStatus) onStatusChanged;
  final ValueChanged<Enquiry> onView;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) => _PageScroll(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PageHeading(
          eyebrow: 'SALES WORKSPACE',
          title: 'Enquiries',
          subtitle: 'Keep every conversation moving, wherever it started.',
          trailing: _exportButton(),
        ),
        const SizedBox(height: 24),
        _EnquiryListCard(
          enquiries: enquiries,
          allEnquiries: allEnquiries,
          searchQuery: searchQuery,
          statusFilter: statusFilter,
          sourceFilter: sourceFilter,
          onSearchChanged: onSearchChanged,
          onStatusFilterChanged: onStatusFilterChanged,
          onSourceFilterChanged: onSourceFilterChanged,
          onStatusChanged: onStatusChanged,
          onView: onView,
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
