# Icemish - Ice Cream Shop Sales Recording App

Icemish is a Flutter-based point-of-sale (POS) system designed for ice cream shops. This app allows shop employees to scan barcodes of products, add them to the cart, and complete sales transactions. It also features user management for cashiers and an admin panel for managing products and users.

## Features

- **Manual Product Addition:** Lookup and add products manually name.
- **Sales Logging:** Save receipts and log daily sales.
- **User Management:** Supports login system for cashiers.
- **Product Management:** cashier can add, update, or remove products and users.
- **Firestore Integration:** Stores product details, user information, and sales logs in Firebase Firestore.
- **State Management:** Utilizes Bloc for state management, ensuring a clean and maintainable codebase.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
- A Firebase project set up with Firestore and Authentication enabled.

### Installation

1. **Clone the Repository:**
    ```sh
    git clone https://github.com/yourusername/icemish.git
    cd icemish
    ```

2. **Install Dependencies:**
    ```sh
    flutter pub get
    ```

3. **Configure Firebase:**
   - Follow the [Firebase setup guide](https://firebase.flutter.dev/docs/overview) to add Firebase to your Flutter project.
   - Place your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) in the respective directories as instructed in the setup guide.

4. **Run the App:**
    ```sh
    flutter run
    ```

## Usage

1. **Login:**
   - Cashiers can log in using their credentials.
   
2. **Manual Addition:**
   - manually search and add products and increase/decrease the sales using the plus and minus buttons.
3. **Checkout:**
   - Complete the transaction and log the sale.

## Contributing

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a pull request.

## License

This project is licensed under the GPLv3 License. See the [LICENSE](LICENSE) file for details.
