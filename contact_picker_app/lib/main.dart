import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactPickerPage(),
    );
  }
}

class ContactPickerPage extends StatefulWidget {
  @override
  _ContactPickerPageState createState() => _ContactPickerPageState();
}

class _ContactPickerPageState extends State<ContactPickerPage> {
  Contact? _contact;

  Future<void> _pickContact() async {
    // Request permissions before opening the contact picker.
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        final Contact? contact =
            await ContactsService.openDeviceContactPicker();
        setState(() {
          _contact = contact;
        });
      } catch (e) {
        print("Error picking contact: $e");
      }
    } else {
      // Handle the case where the user refuses to grant permissions.
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Permissions error"),
          content: Text("Please grant contacts access in the system settings."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickContact,
              child: Text('Choose Contact'),
            ),
            if (_contact != null) ...[
              Text('Name: ${_contact!.displayName}'),
              Text('Phone: ${_contact!.phones?.first.value ?? 'N/A'}'),
            ]
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ContactPickerPage(),
//     );
//   }
// }

// class ContactPickerPage extends StatefulWidget {
//   @override
//   _ContactPickerPageState createState() => _ContactPickerPageState();
// }

// class _ContactPickerPageState extends State<ContactPickerPage> {
//   Contact? _contact;

//   Future<void> _pickContact() async {
//     try {
//       final Contact? contact = await ContactsService.openDeviceContactPicker();
//       setState(() {
//         _contact = contact;
//       });
//     } catch (e) {
//       print("Error picking contact: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contact Picker Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: _pickContact,
//               child: Text('Choose Contact'),
//             ),
//             if (_contact != null) ...[
//               Text('Name: ${_contact!.displayName}'),
//               Text('Phone: ${_contact!.phones?.first.value ?? 'N/A'}'),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
