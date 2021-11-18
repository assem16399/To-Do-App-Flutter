import 'package:flutter/material.dart';

class ArchivedTab extends StatefulWidget {
  const ArchivedTab({Key? key}) : super(key: key);

  @override
  _ArchivedTabState createState() => _ArchivedTabState();
}

class _ArchivedTabState extends State<ArchivedTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Archived'),
    );
  }
}
