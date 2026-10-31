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
  });

  final String id;
  final String name;
  final String company;
  final String email;
  final String phone;
  final String occasion;
  final String product;
  final int quantity;
  final String budget;
  final String date;
  final String source;
  final String message;
  EnquiryStatus status;
}
