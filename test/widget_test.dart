import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mtbs_app/core/widgets/network_image_card.dart';

void main() {
  testWidgets('network image placeholder is accessible', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            height: 180,
            child: NetworkImageCard(imageUrl: null),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
  });
}
