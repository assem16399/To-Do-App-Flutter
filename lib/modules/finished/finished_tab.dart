import 'package:flutter/material.dart';

class FinishedTab extends StatefulWidget {
  const FinishedTab({Key? key}) : super(key: key);

  @override
  _FinishedTabState createState() => _FinishedTabState();
}

class _FinishedTabState extends State<FinishedTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Finished'),
    );
  }
}
