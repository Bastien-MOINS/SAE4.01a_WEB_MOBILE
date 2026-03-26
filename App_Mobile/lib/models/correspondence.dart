import 'package:flutter/material.dart';

enum Correspondence { direct, one, two }

class SlidingBoxCorrespondence extends StatefulWidget {
  const SlidingBoxCorrespondence({super.key});

  @override
  State<SlidingBoxCorrespondence> createState() => _SlidingBoxCorrespondenceState();
}

class _SlidingBoxCorrespondenceState extends State<SlidingBoxCorrespondence> {
  Correspondence? _correspondence = Correspondence.direct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Selected: $_correspondence'),
        RadioGroup<Correspondence>(
          groupValue: _correspondence,
          onChanged: (Correspondence? value) {
            setState(() {
              _correspondence = value;
            });
          },
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Vol direct'),
                leading: Radio<Correspondence>(
                  value: Correspondence.direct,
                ),
              ),
              ListTile(
                title: const Text('1 correspondance'),
                leading: Radio<Correspondence>(
                  value: Correspondence.one,
                ),
              ),
              ListTile(
                title: const Text('2 correspondances'),
                leading: Radio<Correspondence>(
                  value: Correspondence.two,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}