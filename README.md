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

The sign-in screen accepts any valid email address and a non-empty password.
This is a demonstration gate, not production authentication.

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

The dashboard uses local sample data. It does not yet connect to an API or
database, and status changes are not persisted between sessions. A production
handover should replace the sample data and demo sign-in with the shared
backend, server-side authentication, and persistent enquiry updates.

## Stack

Flutter and Dart were chosen to keep the admin interface in the existing
Flutter project while supporting both a responsive web build and mobile-sized
layouts.

## Tests

```sh
flutter test
flutter analyze
```
