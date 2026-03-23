import 'package:flutter/material.dart';

// Enum values must be valid identifiers, not numbers.
enum Correspondence { direct, one, two }

class SlidingBoxCorrespondence extends StatefulWidget {
  const SlidingBoxCorrespondence({super.key});

  @override
  State<SlidingBoxCorrespondence> createState() => _SlidingBoxCorrespondenceState();
}

// Move the State class outside the StatefulWidget class.
class _SlidingBoxCorrespondenceState extends State<SlidingBoxCorrespondence> {
  Correspondence? _correspondence = Correspondence.direct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Selected: $_correspondence'),
        ListTile(
          title: const Text('Vol direct'),
          leading: Radio<Correspondence>(
            value: Correspondence.direct,
            groupValue: _correspondence,
            onChanged: (Correspondence? value) {
              setState(() {
                _correspondence = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('1 correspondance'),
          leading: Radio<Correspondence>(
            value: Correspondence.one,
            groupValue: _correspondence,
            onChanged: (Correspondence? value) {
              setState(() {
                _correspondence = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('2 correspondances'),
          leading: Radio<Correspondence>(
            value: Correspondence.two,
            groupValue: _correspondence,
            onChanged: (Correspondence? value) {
              setState(() {
                _correspondence = value;
              });
            },
          ),
        ),
      ],
    );
  }
}