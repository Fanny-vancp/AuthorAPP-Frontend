import 'package:flutter/material.dart';

class RelationLine {
  final Offset start;
  final Offset end;
  final String label;

  RelationLine({
    required this.start, 
    required this.end,
    required this.label,
  });
}