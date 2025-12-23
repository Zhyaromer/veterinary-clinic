import 'package:flutter/material.dart';
import 'package:vet_clinic/screens/homescreen.dart';
import '../../models/cart_item.dart';
import 'checkout_page.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        elevation: 0,
        backgroundColor: const Color(0xFF4A6FA5),
        foregroundColor: Colors.white,
      ),
      body: globalCart.items.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar: globalCart.items.isEmpty
          ? null
          : _buildCheckoutBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Your Cart is Empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items from our store to get started',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A6FA5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Cart Items List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: globalCart.items.length,
            itemBuilder: (context, index) {
              final item = globalCart.items[index];
              return _buildCartItemCard(item);
            },
          ),
          // Price Summary
          _buildPriceSummary(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              color: item.categoryColor.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: item.categoryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.image_not_supported,
                      color: item.categoryColor.withOpacity(0.3),
                    ),
                  );
                },
              ),
            ),
          ),
          // Product Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Name and Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: item.categoryColor,
                        ),
                      ),
                    ],
                  ),
                  // Quantity Controls and Remove
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              iconSize: 18,
                              onPressed: () {
                                setState(() {
                                  if (item.quantity > 1) {
                                    globalCart.updateQuantity(
                                      item.id,
                                      item.quantity - 1,
                                    );
                                  }
                                });
                              },
                              splashRadius: 20,
                            ),
                            Container(
                              width: 32,
                              alignment: Alignment.center,
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              iconSize: 18,
                              onPressed: () {
                                setState(() {
                                  if (item.quantity < item.maxQuantity) {
                                    globalCart.updateQuantity(
                                      item.id,
                                      item.quantity + 1,
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                          'Maximum Quantity Reached',
                                        ),
                                        content: Text(
                                          'Maximum available quantity (${item.maxQuantity}) reached for ${item.name}',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                });
                              },
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      // Remove Button
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red[400],
                        ),
                        onPressed: () {
                          final removedItem = item;
                          setState(() {
                            globalCart.removeItem(item.id);
                          });
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Item Removed'),
                              content: Text(
                                '${item.name} has been removed from your cart',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      globalCart.addItem(removedItem);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Undo'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        splashRadius: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A6FA5).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4A6FA5).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'Subtotal',
            '\$${globalCart.subtotal.toStringAsFixed(2)}',
            isBold: false,
          ),
          const SizedBox(height: 12),
          _buildPriceRow(
            'Tax (10%)',
            '\$${globalCart.tax.toStringAsFixed(2)}',
            isBold: false,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _buildPriceRow(
            'Total',
            '\$${globalCart.total.toStringAsFixed(2)}',
            isBold: true,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFF4A6FA5) : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFF4A6FA5) : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${globalCart.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A6FA5),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          subtotal: globalCart.subtotal,
                          tax: globalCart.tax,
                          total: globalCart.total,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6FA5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
