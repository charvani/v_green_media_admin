part of '../admin_app.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final _enquiries = _demoEnquiries();
  bool _isLoggedIn = false;
  bool _isLoadingEnquiries = false;
  bool _showEnquiries = false;
  String? _firestoreError;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _enquirySubscription;
  String _searchQuery = '';
  String _statusFilter = 'All statuses';
  String _sourceFilter = 'All sources';

  List<Enquiry> get _filteredEnquiries {
    final query = _searchQuery.trim().toLowerCase();
    return _enquiries.where((enquiry) {
      final matchesSearch =
          query.isEmpty ||
          <String>[
            enquiry.id,
            enquiry.name,
            enquiry.company,
            enquiry.email,
            enquiry.product,
            enquiry.otherInfo,
          ].any((value) => value.toLowerCase().contains(query));
      final matchesStatus =
          _statusFilter == 'All statuses' ||
          enquiry.status.label == _statusFilter;
      final matchesSource =
          _sourceFilter == 'All sources' || enquiry.source == _sourceFilter;
      return matchesSearch && matchesStatus && matchesSource;
    }).toList();
  }

  Future<void> _login(String email, String password) async {
    if (Firebase.apps.isNotEmpty) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
    }
    if (!mounted) return;
    setState(() => _isLoggedIn = true);
    if (Firebase.apps.isNotEmpty) _listenToEnquiries();
  }

  void _listenToEnquiries() {
    unawaited(_enquirySubscription?.cancel());
    setState(() {
      _isLoadingEnquiries = true;
      _firestoreError = null;
      _enquiries.clear();
    });
    _enquirySubscription = FirebaseFirestore.instance
        .collection('enquiries')
        .snapshots()
        .listen(
          (snapshot) {
            if (!mounted) return;
            final enquiries = snapshot.docs
                .map(
                  (document) =>
                      Enquiry.fromFirestore(document.id, document.data()),
                )
                .toList();
            setState(() {
              _enquiries
                ..clear()
                ..addAll(enquiries);
              if (_sourceFilter != 'All sources' &&
                  !enquiries.any((item) => item.source == _sourceFilter)) {
                _sourceFilter = 'All sources';
              }
              _isLoadingEnquiries = false;
              _firestoreError = null;
            });
          },
          onError: (Object error) {
            if (!mounted) return;
            setState(() {
              _isLoadingEnquiries = false;
              _firestoreError = 'Could not load enquiries: $error';
            });
          },
        );
  }

  Future<void> _logout() async {
    try {
      if (Firebase.apps.isNotEmpty) await FirebaseAuth.instance.signOut();
    } on FirebaseException catch (error) {
      if (mounted) {
        _showNotice('Could not sign out: ${error.message ?? error.code}');
      }
      return;
    }
    unawaited(_enquirySubscription?.cancel());
    _enquirySubscription = null;
    if (!mounted) return;
    setState(() {
      _isLoggedIn = false;
      _showEnquiries = false;
      _isLoadingEnquiries = false;
    });
  }

  Future<void> _updateStatus(Enquiry enquiry, EnquiryStatus status) async {
    final previousStatus = enquiry.status;
    setState(() => enquiry.status = status);
    if (Firebase.apps.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection('enquiries')
          .doc(enquiry.id)
          .update({'status': status.label});
    } on FirebaseException catch (error) {
      if (!mounted) return;
      setState(() => enquiry.status = previousStatus);
      _showNotice('Could not update enquiry status: ${error.message}');
    }
  }

  Future<void> _exportCsv() async {
    final rows = <List<String>>[
      [
        'Enquiry ID',
        'Name',
        'Company',
        'Email',
        'Phone',
        'Occasion',
        'Delivery date',
        'Product',
        'Products selected',
        'Quantity',
        'Budget per unit',
        'Customisation needed',
        'Other information',
        'Enquiry date',
        'Source',
        'Status',
        'Message',
      ],
      ..._enquiries.map(
        (enquiry) => [
          enquiry.id,
          enquiry.name,
          enquiry.company,
          enquiry.email,
          enquiry.phone,
          enquiry.occasion,
          enquiry.deliveryDate,
          enquiry.product,
          enquiry.productsSelected.join('; '),
          enquiry.quantity.toString(),
          enquiry.budget,
          enquiry.customisations.join('; '),
          enquiry.otherInfo,
          enquiry.date,
          enquiry.source,
          enquiry.status.label,
          enquiry.message,
        ],
      ),
    ];
    final csv = rows.map((row) => row.map(_escapeCsv).join(',')).join('\r\n');
    if (kIsWeb) {
      await downloadCsv('tribe-green-enquiries.csv', csv);
      if (mounted) _showNotice('Your enquiries CSV has been downloaded.');
    } else if (mounted) {
      _showNotice('CSV download is available in the web version.');
    }
  }

  String _escapeCsv(String value) => '"${value.replaceAll('"', '""')}"';

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    unawaited(_enquirySubscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginPage(onLogin: _login);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 920;
        return Scaffold(
          drawer: compact ? _buildDrawer() : null,
          appBar: compact
              ? AppBar(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  title: const BrandMark(compact: true),
                  actions: [_profileButton()],
                )
              : null,
          body: Row(
            children: [
              if (!compact) _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    if (!compact) _buildTopBar(),
                    if (_firestoreError != null)
                      MaterialBanner(
                        content: Text(_firestoreError!),
                        leading: const Icon(
                          Icons.cloud_off_outlined,
                          color: Color(0xFFAA5C5C),
                        ),
                        actions: [
                          TextButton(
                            onPressed: _listenToEnquiries,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    Expanded(
                      child: _isLoadingEnquiries
                          ? const Center(child: CircularProgressIndicator())
                          : _showEnquiries
                          ? _buildEnquiriesPage()
                          : _buildDashboard(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar() => SizedBox(
    width: 248,
    child: _Sidebar(
      selectedEnquiries: _showEnquiries,
      enquiryCount: _enquiries.length,
      onSelect: (showEnquiries) => setState(() {
        _showEnquiries = showEnquiries;
        _searchQuery = '';
        _statusFilter = 'All statuses';
        _sourceFilter = 'All sources';
      }),
      onLogout: () => unawaited(_logout()),
    ),
  );

  Widget _buildDrawer() => Drawer(
    child: _Sidebar(
      selectedEnquiries: _showEnquiries,
      enquiryCount: _enquiries.length,
      onSelect: (showEnquiries) {
        setState(() {
          _showEnquiries = showEnquiries;
          _searchQuery = '';
          _statusFilter = 'All statuses';
          _sourceFilter = 'All sources';
        });
        Navigator.of(context).pop();
      },
      onLogout: () => unawaited(_logout()),
    ),
  );

  Widget _buildTopBar() => Container(
    height: 76,
    padding: const EdgeInsets.symmetric(horizontal: 32),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Color(0xFFEAEEEA))),
    ),
    child: Row(
      children: [
        const Spacer(),
        const Icon(Icons.calendar_today_outlined, size: 16, color: _muted),
        const SizedBox(width: 9),
        Text(
          _formatFullDate(DateTime.now()),
          style: TextStyle(color: _muted, fontSize: 13),
        ),
        const SizedBox(width: 24),
        _profileButton(),
      ],
    ),
  );

  Widget _profileButton() => PopupMenuButton<String>(
    tooltip: 'Account menu',
    onSelected: (value) {
      if (value == 'logout') unawaited(_logout());
    },
    itemBuilder: (context) => const [
      PopupMenuItem(value: 'logout', child: Text('Log out')),
    ],
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(
          radius: 17,
          backgroundColor: Color(0xFFE4EFE7),
          child: Text(
            'TG',
            style: TextStyle(
              color: _forest,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (MediaQuery.sizeOf(context).width > 520) ...[
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tribe Green',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              Text(
                'Administrator',
                style: TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 7),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: _muted),
        ],
      ],
    ),
  );

  Widget _buildDashboard() => DashboardScreen(
    enquiries: _enquiries,
    onExport: _exportCsv,
    onStatusChanged: _updateStatus,
    onView: _showEnquiryDetails,
    onViewAll: () => setState(() => _showEnquiries = true),
  );

  Widget _buildEnquiriesPage() => EnquiriesScreen(
    enquiries: _filteredEnquiries,
    allEnquiries: _enquiries,
    searchQuery: _searchQuery,
    statusFilter: _statusFilter,
    sourceFilter: _sourceFilter,
    onSearchChanged: (value) => setState(() => _searchQuery = value),
    onStatusFilterChanged: (value) => setState(() => _statusFilter = value),
    onSourceFilterChanged: (value) => setState(() => _sourceFilter = value),
    onStatusChanged: _updateStatus,
    onView: _showEnquiryDetails,
    onExport: _exportCsv,
  );

  void _showEnquiryDetails(Enquiry enquiry) {
    showDialog<void>(
      context: context,
      builder: (context) => _EnquiryDetailsDialog(
        enquiry: enquiry,
        onStatusChanged: (status) {
          _updateStatus(enquiry, status);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
