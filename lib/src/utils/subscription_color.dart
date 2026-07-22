import 'package:flutter/material.dart';

/// A curated palette of 12 visually distinct colors, one per "slot" around
/// the color wheel. Using a fixed palette guarantees that no two subscriptions
/// ever produce a similar-looking color, regardless of their names.
const _palette = [
  Color(0xFFE53935), // Red
  Color(0xFFD81B60), // Pink
  Color(0xFF8E24AA), // Purple
  Color(0xFF3949AB), // Indigo
  Color(0xFF1E88E5), // Blue
  Color(0xFF00ACC1), // Cyan
  Color(0xFF00897B), // Teal
  Color(0xFF43A047), // Green
  Color(0xFFC0CA33), // Lime
  Color(0xFFFB8C00), // Orange
  Color(0xFFFF7043), // Deep Orange
  Color(0xFF6D4C41), // Brown
];

/// Generates a deterministic color from a subscription [name].
/// Uses djb2 hash to pick from a curated palette of 12 visually distinct colors.
Color subscriptionColor(String name) {
  int hash = 5381;
  for (final c in name.codeUnits) {
    hash = ((hash * 33) ^ c) & 0x7FFFFFFF;
  }
  return _palette[hash % _palette.length];
}
