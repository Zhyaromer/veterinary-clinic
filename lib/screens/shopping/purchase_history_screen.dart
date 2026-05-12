import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/purchase.dart';
import '../../providers/auth_provider.dart';
import '../../services/purchases_firestore_service.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  String _prettyType(String value) {
    switch (value) {
      case 'food':
        return 'Food';
      case 'toy':
        return 'Toy';
      case 'cage':
        return 'Cage';
      case 'medicine':
        return 'Medicine';
      default:
        return value.isEmpty ? 'Item' : value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final service = PurchasesFirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
        backgroundColor: const Color(0xFF4A6FA5),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade50,
      body: user == null
          ? const Center(child: Text('Please sign in to view purchases.'))
          : StreamBuilder<List<Purchase>>(
              stream: service.getPurchasesStreamForUser(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final purchases = snapshot.data ?? [];
                if (purchases.isEmpty) {
                  return const Center(child: Text('No purchases yet.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {
                    final p = purchases[index];
                    final dateText = DateFormat(
                      'MMM d, yyyy • h:mm a',
                    ).format(p.purchasedAt);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: p.imageUrl.isEmpty
                              ? Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.shopping_bag_outlined,
                                  ),
                                )
                              : Image.network(
                                  p.imageUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 56,
                                      height: 56,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    );
                                  },
                                ),
                        ),
                        title: Text(
                          p.itemName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${_prettyType(p.itemType)} • Qty ${p.quantity}\n$dateText',
                        ),
                        isThreeLine: true,
                        trailing: Text(
                          '\$${p.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A6FA5),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
