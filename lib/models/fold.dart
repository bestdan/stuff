import 'dart:math';

void main() {
  final items = [1, 2, 3];

  final x = items.fold<int>(0, (i, item) => max(i, item));
  print(x);
}
