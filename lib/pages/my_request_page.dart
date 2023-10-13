import 'package:flutter/material.dart';

class MyRequestPage extends StatefulWidget {
  const MyRequestPage({super.key});

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Permintaan-Permintaan anda akan tampil disini",
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
                'Setelah permintaan ditambahkan, maka daftar permintaan yang anda miliki akan muncul disini',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 115,
              height: 35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ABB3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 5),
                onPressed: () async {

                },
                child: const Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 4),
                    Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
