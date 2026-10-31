part of '../admin_app.dart';

enum EnquiryStatus { newEnquiry, contacted, converted, lost }

extension EnquiryStatusLabel on EnquiryStatus {
  String get label => switch (this) {
    EnquiryStatus.newEnquiry => 'New',
    EnquiryStatus.contacted => 'Contacted',
    EnquiryStatus.converted => 'Converted',
    EnquiryStatus.lost => 'Lost',
  };
}

class Enquiry {
  Enquiry({
    required this.id,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
    required this.occasion,
    required this.product,
    required this.quantity,
    required this.budget,
    required this.date,
    required this.source,
    required this.status,
    required this.message,
    this.deliveryDate = '',
    this.productsSelected = const [],
    this.customisations = const [],
    this.otherInfo = '',
  });

  final String id;
  final String name;
  final String company;
  final String email;
  final String phone;
  final String occasion;
  final String deliveryDate;
  final String product;
  final List<String> productsSelected;
  final List<String> customisations;
  final int quantity;
  final String budget;
  final String date;
  final String source;
  final String message;
  final String otherInfo;
  EnquiryStatus status;

  factory Enquiry.fromFirestore(String id, Map<String, dynamic> data) {
    final products = _firestoreStringList(
      data['products_selected'] ?? data['productsSelected'],
    );
    final customisations = _firestoreStringList(
      data['customisation_needed'] ?? data['customisations'],
    );
    final deliveryDate = _firestoreDate(
      data['delivery_date'] ?? data['deliveryDate'],
    );
    final receivedDate = _firestoreDate(
      data['created_at'] ??
          data['createdAt'] ??
          data['submitted_at'] ??
          data['submittedAt'] ??
          data['date'],
    );
    final rawStatus = _firestoreString(data['status']).toLowerCase();
    final status = EnquiryStatus.values.firstWhere(
      (value) => value.label.toLowerCase() == rawStatus,
      orElse: () => EnquiryStatus.newEnquiry,
    );
    final rawSource = _firestoreString(data['enquiry_from']).toLowerCase();
    final source = switch (rawSource) {
      'mobile' || 'mobile app' || 'app' => 'Mobile app',
      'web' || 'website' => 'Website',
      '' => 'Website',
      _ => rawSource[0].toUpperCase() + rawSource.substring(1),
    };
    final budgetValue = data['budget_per_unit'] ?? data['budget'];

    return Enquiry(
      id: id,
      name: _firestoreString(data['name']),
      company: _firestoreString(data['company']),
      email: _firestoreString(data['email']),
      phone: _firestoreString(data['phone']),
      occasion: _firestoreString(data['occasion']),
      deliveryDate: deliveryDate,
      product: products.isEmpty
          ? _firestoreString(data['product'])
          : products.join(', '),
      productsSelected: products,
      customisations: customisations,
      quantity: _firestoreNumber(data['number_of_units'] ?? data['quantity']),
      budget: budgetValue is num
          ? '₹${budgetValue.toString()}'
          : _firestoreString(budgetValue),
      date: receivedDate.isEmpty ? '—' : receivedDate,
      source: source,
      status: status,
      message: _firestoreString(data['message']),
      otherInfo: _firestoreString(data['other_info']),
    );
  }
}

String _firestoreString(Object? value) => value?.toString() ?? '';

int _firestoreNumber(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

List<String> _firestoreStringList(Object? value) {
  if (value is! Iterable) return const [];
  return value.map(_firestoreString).where((item) => item.isNotEmpty).toList();
}

String _firestoreDate(Object? value) {
  DateTime? date;
  if (value is Timestamp) {
    date = value.toDate();
  } else if (value is DateTime) {
    date = value;
  } else if (value is String) {
    date = DateTime.tryParse(value);
    if (date == null) return value;
  }
  if (date == null) return '';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final localDate = date.toLocal();
  return '${localDate.day} ${months[localDate.month - 1]} ${localDate.year}';
}
