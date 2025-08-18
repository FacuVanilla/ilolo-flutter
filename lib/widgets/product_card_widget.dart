import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productTitle;
  final String productLocation;
  final double productPrice;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;

  const ProductCard({super.key, 
    required this.imageUrl,
    required this.productTitle,
    required this.productLocation,
    required this.productPrice,
    required this.isBookmarked,
    required this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imageUrl,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              productTitle,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              productLocation,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\$${productPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.blue,
                ),
                onPressed: onBookmarkTap,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement the "Buy" functionality here
                  },
                  child: const Text('Buy'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}