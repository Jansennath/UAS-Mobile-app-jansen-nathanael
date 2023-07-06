import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'temperature_page.dart';
import 'humidity_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference lockRef =
      FirebaseDatabase.instance.reference().child('lock');
  bool isLocked = true;
  String lockButtonLabel = 'Lock';

  @override
  void initState() {
    super.initState();
    lockRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          isLocked = snapshot.value == 1;
          lockButtonLabel = isLocked ? 'Lock' : 'Unlock';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 150,
              height: 150,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TemperaturePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.thermostat, size: 48),
                label: Text('Temperature', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 150,
              height: 150,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HumidityPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.opacity, size: 48),
                label: Text('Humidity', style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 150,
              height: 150,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Toggle the lock status
                  isLocked = !isLocked;

                  // Update the lock value in the Firebase Realtime Database
                  lockRef.set(isLocked ? 1 : 0);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(Icons.lock, size: 48),
                label: Text(lockButtonLabel, style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
