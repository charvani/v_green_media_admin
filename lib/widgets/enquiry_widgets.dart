part of '../admin_app.dart';

class _EnquiryListCard extends StatelessWidget {
  const _EnquiryListCard({
    required this.enquiries,
    required this.allEnquiries,
    required this.onStatusChanged,
    required this.onView,
    this.showFilters = true,
    this.title,
    this.subtitle,
    this.searchQuery = '',
    this.statusFilter = 'All statuses',
    this.sourceFilter = 'All sources',
    this.onSearchChanged,
    this.onStatusFilterChanged,
    this.onSourceFilterChanged,
    this.onViewAll,
  });

  final List<Enquiry> enquiries;
  final List<Enquiry> allEnquiries;
  final ValueChanged<Enquiry> onView;
  final void Function(Enquiry, EnquiryStatus) onStatusChanged;
  final bool showFilters;
  final String? title;
  final String? subtitle;
  final String searchQuery;
  final String statusFilter;
  final String sourceFilter;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onStatusFilterChanged;
  final ValueChanged<String>? onSourceFilterChanged;
  final VoidCallback? onViewAll;

  List<String> get _sourceOptions {
    final sources = allEnquiries.map((item) => item.source).toSet().toList()
      ..sort();
    return ['All sources', ...sources];
  }

  @override
  Widget build(BuildContext context) => _Panel(
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 19, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'All enquiries',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        subtitle!,
                        style: const TextStyle(color: _muted, fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: const Text(
                    'View all',
                    style: TextStyle(color: _green, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        if (showFilters) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 620;
                final search = TextField(
                  key: const Key('enquiry_search'),
                  onChanged: onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search name, company or enquiry ID',
                    prefixIcon: Icon(Icons.search_rounded, size: 19),
                    isDense: true,
                  ),
                );
                final filters = Row(
                  children: [
                    Expanded(
                      child: _FilterDropdown(
                        value: statusFilter,
                        options: const [
                          'All statuses',
                          'New',
                          'Contacted',
                          'Converted',
                          'Lost',
                        ],
                        onChanged: onStatusFilterChanged,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _FilterDropdown(
                        value: sourceFilter,
                        options: _sourceOptions,
                        onChanged: onSourceFilterChanged,
                      ),
                    ),
                  ],
                );
                if (compact) {
                  return Column(
                    children: [search, const SizedBox(height: 9), filters],
                  );
                }
                return Row(
                  children: [
                    Expanded(flex: 3, child: search),
                    const SizedBox(width: 10),
                    Expanded(flex: 2, child: filters),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 11),
            child: Text(
              '${enquiries.length} of ${allEnquiries.length} enquiries',
              style: const TextStyle(color: _muted, fontSize: 11),
            ),
          ),
        ],
        if (enquiries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 42, horizontal: 20),
            child: Center(
              child: Text(
                'No enquiries match these filters.',
                style: TextStyle(color: _muted, fontSize: 13),
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 680) {
                return Column(
                  children: [
                    for (var index = 0; index < enquiries.length; index++) ...[
                      _EnquiryMobileCard(
                        enquiry: enquiries[index],
                        onStatusChanged: onStatusChanged,
                        onView: onView,
                      ),
                      if (index < enquiries.length - 1)
                        const Divider(height: 1, color: Color(0xFFEEF1EE)),
                    ],
                  ],
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 42,
                  dataRowMinHeight: 64,
                  dataRowMaxHeight: 72,
                  horizontalMargin: 20,
                  columnSpacing: 22,
                  headingRowColor: const WidgetStatePropertyAll(
                    Color(0xFFF8FAF8),
                  ),
                  columns: const [
                    DataColumn(label: _TableHeader('CUSTOMER')),
                    DataColumn(label: _TableHeader('PRODUCT / OCCASION')),
                    DataColumn(label: _TableHeader('QUANTITY')),
                    DataColumn(label: _TableHeader('SOURCE')),
                    DataColumn(label: _TableHeader('DELIVERY DATE')),
                    DataColumn(label: _TableHeader('STATUS')),
                    DataColumn(label: _TableHeader('')),
                  ],
                  rows: enquiries
                      .map(
                        (enquiry) => DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 145,
                                child: _CustomerCell(enquiry: enquiry),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 170,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      enquiry.product,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: _ink,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      enquiry.occasion,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: _muted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${enquiry.quantity}',
                                style: const TextStyle(
                                  color: _ink,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            DataCell(_SourceTag(source: enquiry.source)),
                            DataCell(
                              Text(
                                enquiry.deliveryDate.isEmpty
                                    ? enquiry.date
                                    : enquiry.deliveryDate,
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            DataCell(
                              _StatusDropdown(
                                status: enquiry.status,
                                onChanged: (status) =>
                                    onStatusChanged(enquiry, status),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                tooltip: 'View enquiry ${enquiry.id}',
                                onPressed: () => onView(enquiry),
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                  color: _muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        if (showFilters && enquiries.isNotEmpty) const SizedBox(height: 12),
      ],
    ),
  );
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: value,
    isExpanded: true,
    decoration: const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 11),
    ),
    style: const TextStyle(color: _ink, fontSize: 12),
    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
    items: options
        .map(
          (option) => DropdownMenuItem(
            value: option,
            child: Text(option, overflow: TextOverflow.ellipsis),
          ),
        )
        .toList(),
    onChanged: (value) {
      if (value != null) onChanged?.call(value);
    },
  );
}

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
      color: _muted,
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.6,
    ),
  );
}

class _CustomerCell extends StatelessWidget {
  const _CustomerCell({required this.enquiry});

  final Enquiry enquiry;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: const Color(0xFFEAF2EB),
        child: Text(
          enquiry.name
              .split(' ')
              .take(2)
              .map((part) => part[0])
              .join()
              .toUpperCase(),
          style: const TextStyle(
            color: _forest,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(width: 9),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              enquiry.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              enquiry.company,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _muted, fontSize: 10),
            ),
          ],
        ),
      ),
    ],
  );
}

class _EnquiryMobileCard extends StatelessWidget {
  const _EnquiryMobileCard({
    required this.enquiry,
    required this.onStatusChanged,
    required this.onView,
  });

  final Enquiry enquiry;
  final void Function(Enquiry, EnquiryStatus) onStatusChanged;
  final ValueChanged<Enquiry> onView;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _CustomerCell(enquiry: enquiry)),
            IconButton(
              tooltip: 'View enquiry ${enquiry.id}',
              onPressed: () => onView(enquiry),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 41, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                enquiry.product,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${enquiry.quantity} units  ·  ${enquiry.deliveryDate.isEmpty ? enquiry.date : enquiry.deliveryDate}',
                style: const TextStyle(color: _muted, fontSize: 10),
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  _SourceTag(source: enquiry.source),
                  const SizedBox(width: 8),
                  _StatusDropdown(
                    status: enquiry.status,
                    onChanged: (status) => onStatusChanged(enquiry, status),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SourceTag extends StatelessWidget {
  const _SourceTag({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final isWebsite = source == 'Website';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: isWebsite ? const Color(0xFFF1F2FA) : const Color(0xFFF0F5F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        source,
        style: TextStyle(
          color: isWebsite ? const Color(0xFF626D9C) : _green,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({required this.status, required this.onChanged});

  final EnquiryStatus status;
  final ValueChanged<EnquiryStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = switch (status) {
      EnquiryStatus.newEnquiry => (
        const Color(0xFFFFF3E4),
        const Color(0xFFAD6C20),
      ),
      EnquiryStatus.contacted => (
        const Color(0xFFEBF0FA),
        const Color(0xFF536B9E),
      ),
      EnquiryStatus.converted => (
        const Color(0xFFE9F4EF),
        const Color(0xFF39805F),
      ),
      EnquiryStatus.lost => (const Color(0xFFFBECEC), const Color(0xFFAA5C5C)),
    };
    return PopupMenuButton<EnquiryStatus>(
      tooltip: 'Change status',
      onSelected: onChanged,
      padding: EdgeInsets.zero,
      itemBuilder: (context) => EnquiryStatus.values
          .map(
            (option) => PopupMenuItem(
              value: option,
              child: Text(option.label, style: const TextStyle(fontSize: 12)),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: colors.$1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: colors.$2,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              status.label,
              style: TextStyle(
                color: colors.$2,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down, size: 13, color: colors.$2),
          ],
        ),
      ),
    );
  }
}

class _EnquiryDetailsDialog extends StatelessWidget {
  const _EnquiryDetailsDialog({
    required this.enquiry,
    required this.onStatusChanged,
  });

  final Enquiry enquiry;
  final ValueChanged<EnquiryStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 510),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        enquiry.id,
                        style: const TextStyle(
                          color: _green,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        enquiry.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        enquiry.company,
                        style: const TextStyle(color: _muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFEAEEEA)),
            const SizedBox(height: 12),
            _DetailLine(label: 'Email', value: enquiry.email),
            _DetailLine(label: 'Phone', value: enquiry.phone),
            _DetailLine(label: 'Product', value: enquiry.product),
            _DetailLine(label: 'Occasion', value: enquiry.occasion),
            if (enquiry.deliveryDate.isNotEmpty)
              _DetailLine(label: 'Delivery date', value: enquiry.deliveryDate),
            _DetailLine(
              label: 'Quantity / budget',
              value: '${enquiry.quantity} units  ·  ${enquiry.budget}',
            ),
            _DetailLine(label: 'Enquiry source', value: enquiry.source),
            _DetailLine(label: 'Received', value: enquiry.date),
            const SizedBox(height: 10),
            const Text(
              'MESSAGE',
              style: TextStyle(
                color: _muted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              enquiry.message,
              style: const TextStyle(color: _ink, fontSize: 13, height: 1.5),
            ),
            if (enquiry.customisations.isNotEmpty) ...[
              const SizedBox(height: 14),
              _DetailLine(
                label: 'Customisation',
                value: enquiry.customisations.join(', '),
              ),
            ],
            if (enquiry.otherInfo.isNotEmpty) ...[
              const SizedBox(height: 14),
              _DetailLine(label: 'Other information', value: enquiry.otherInfo),
            ],
            const SizedBox(height: 22),
            const Text(
              'UPDATE STATUS',
              style: TextStyle(
                color: _muted,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: EnquiryStatus.values.map((status) {
                final selected = status == enquiry.status;
                return OutlinedButton(
                  onPressed: selected ? null : () => onStatusChanged(status),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: selected ? _forest : _muted,
                    backgroundColor: selected
                        ? const Color(0xFFEAF2EB)
                        : Colors.white,
                    side: BorderSide(
                      color: selected
                          ? const Color(0xFFC8DCCB)
                          : const Color(0xFFE5EAE5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                  ),
                  child: Text(
                    status.label,
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 11),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
