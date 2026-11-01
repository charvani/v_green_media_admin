# V Green Media Admin

A responsive Flutter web admin panel for reviewing corporate gifting enquiries.

## Run locally

Install the Flutter SDK and Chrome, then run:

```sh
flutter pub get
flutter run -d chrome
```

The web Firebase options are in `lib/firebase_options.dart`. The app uses the
`v-green-media` Firebase project; enable Email/Password in Firebase
Authentication and provision the intended admin accounts in the Firebase
Console. Firestore rules must allow those signed-in admins to read and update
the `enquiries` collection. Do not allow public reads or writes. The app
currently has Firebase options for web only.

To build website used flutter terminal commands build and firebase hosting deploy for the web app:


The deploy command requires the Firebase CLI, access to the configured project,
and the `admin` Hosting target.

## What it does

- Overview cards and an enquiry list with details, status, source, and dates.
- Search by enquiry ID, customer, company, email, or product; filter by status
  and source.
- Update enquiry status in Firestore and export enquiries as CSV.
- Responsive layouts for desktop, tablet, and mobile-sized screens.

The dashboard listens to the Firestore `enquiries` collection in real time.
Documents use fields including `name`, `company`, `email`, `phone`, `occasion`,
`number_of_units`, `budget_per_unit`, `delivery_date`, `products_selected`,
`customisation_needed`, `message`, `other_info`, and `enquiry_from`. Optional
`status`, `created_at`, and `submitted_at` fields are also read. Missing status
defaults to **New**; status changes write back to the document.

## Stack and structure

- **Flutter / Dart** provide the existing app foundation and let one UI adapt
  across screen sizes.
- **Firebase Authentication** handles production sign-in; **Cloud Firestore**
  supplies live enquiry data and persists status changes without a separate
  application server.
- **`web`** provides browser APIs for downloading the CSV export.

`lib/main.dart` initializes Firebase and starts the app. `lib/admin_app.dart`
sets up the theme and includes the screens, model, demo data, and widgets via
Dart `part` files under `lib/screens/`, `lib/models/`, `lib/data/`, and
`lib/widgets/`. Web-specific CSV download code is in `lib/csv_download_web.dart`.


hours spent: 10
