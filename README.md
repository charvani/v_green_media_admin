# Tribe Green Admin

A responsive Flutter web admin panel for reviewing corporate gifting enquiries.

## Run locally

```sh
flutter pub get
flutter run -d chrome
```

For a release web build:

```sh
flutter build web
```

## Demo access

Firebase is initialized from the generated `lib/firebase_options.dart` file.
Enable Email/Password sign-in in Firebase Authentication and create admin
user `vgreen@gmail.com` in the Firebase Console with the password managed
there. The app only accepts that admin email when Firebase is configured, and
Firebase Authentication verifies the password; passwords are not stored in
the Flutter source. When Firebase is unavailable in widget tests, the
sign-in screen uses its demo-only gate.

## Firestore data

After an admin signs in, the dashboard listens in real time to the Firestore
`enquiries` collection. Existing documents are mapped from the fields used by
the enquiry form:

- `name`, `company`, `email`, `phone`, and `occasion`
- `number_of_units` and numeric `budget_per_unit`
- `delivery_date` (Firestore timestamp)
- `products_selected` and `customisation_needed` (arrays of strings)
- `message`, `other_info`, and `enquiry_from` (`mobile` is displayed as
  “Mobile app”)
- optional `status`, `created_at`, or `submitted_at`

Documents without a `status` appear as **New**. Changing an enquiry status
writes the `status` field back to the same Firestore document. The list,
dashboard totals, search, source filters, details, and CSV export use the
Firestore records.

The app's admin login must be authorized by Firebase Authentication and your
Firestore rules must permit the signed-in admin to read and update enquiry
documents. Keep the existing website/app submission rules separate as needed;
do not make enquiry reads publicly accessible.

## What is included

- Overview cards for total, new, contacted, and converted enquiries.
- Enquiry list with customer and product details, source, status, and date.
- Search by enquiry ID, customer, company, email, or product.
- Filters by status and source, and inline status updates.
- Enquiry detail view and CSV download.
- Responsive layouts for desktop, tablet, and mobile.

## Source layout

- `lib/main.dart` starts the app.
- `lib/admin_app.dart` configures the app theme and composes its feature files.
- `lib/screens/` contains the login, dashboard, enquiries, and navigation shell.
- `lib/widgets/` contains shared dashboard, navigation, and enquiry components.
- `lib/models/` and `lib/data/` contain the enquiry model and demo data.

The dashboard's local sample data is used only when Firebase has not been
initialized (such as in isolated widget tests).

## Stack

Flutter and Dart were chosen to keep the admin interface in the existing
Flutter project while supporting both a responsive web build and mobile-sized
layouts.

## Tests

```sh
flutter test
flutter analyze
```
