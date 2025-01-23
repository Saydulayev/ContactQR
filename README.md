# ContactQR

**ContactQR** is a SwiftUI-based app designed to streamline contact management using QR codes. It enables users to generate, share, and scan QR codes, organize contacts, and set reminders for follow-ups.

---

## Features

- **QR Code Generation**: Instantly create QR codes from your name and email address.
- **QR Code Sharing**: Share generated QR codes via a context menu.
- **Contact Management**: Organize contacts into "Contacted" and "Uncontacted" categories.
- **QR Code Scanning**: Quickly scan QR codes to add new contacts.
- **Reminders**: Set notifications to remind yourself to follow up with contacts.
- **Bulk Actions**: Edit and delete multiple contacts simultaneously.

---

## Tech Stack

- **SwiftUI**: For building modern and responsive user interfaces.
- **CoreImage**: To generate high-quality QR codes.
- **CodeScanner**: For seamless QR code scanning.
- **UserNotifications**: For managing local notifications.
- **SwiftData**: To handle contact data persistence.
- **AppStorage**: To store user preferences like name and email.

---

## How It Works

1. **Generate a QR Code**:
   - Navigate to the "Me" tab.
   - Enter your name and email address to create a personalized QR code.
   - Long-press the QR code to share it.

2. **Scan a QR Code**:
   - Go to the "Everyone" tab.
   - Tap the "Scan" button to open the QR code scanner.
   - Add scanned contacts to your list.

3. **Organize Contacts**:
   - Swipe left to mark contacts as "Contacted" or "Uncontacted."
   - Use the edit button to delete multiple contacts at once.

4. **Set Reminders**:
   - Swipe left on a contact and tap "Remind Me" to schedule a notification.

---

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/contactqr.git
