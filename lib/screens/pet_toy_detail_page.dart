// screens/pet_toy_detail_page.dart
import 'package:flutter/material.dart';
import 'package:vet_clinic/screens/homescreen.dart';
import '../models/pet_toy.dart';
import '../models/cart_item.dart';

class PetToyDetailPage extends StatefulWidget {
  final PetToy petToy;

  const PetToyDetailPage({super.key, required this.petToy});

  @override
  State<PetToyDetailPage> createState() => _PetToyDetailPageState();
}

class _PetToyDetailPageState extends State<PetToyDetailPage> {
  late int _selectedQuantity;

  @override
  void initState() {
    super.initState();
    _selectedQuantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    final petToy = widget.petToy;
    final petTypeColor = petToy.getPetTypeColor();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 450,
            floating: false,
            pinned: false,
            snap: false,
            stretch: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Toy Image
                  Image.network(
                    petToy.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: petTypeColor.withOpacity(0.2),
                        child: Center(
                          child: Icon(
                            petToy.getPetTypeIcon(),
                            size: 100,
                            color: petTypeColor,
                          ),
                        ),
                      );
                    },
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      petToy.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      petToy.category,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ],
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.share, color: Colors.black, size: 20),
                ),
                onPressed: () {},
              ),
            ],
          ),

          // Quantity Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final cartItem = CartItem(
                            id: 'toy_${petToy.id}',
                            name: petToy.name,
                            price: petToy.price,
                            imageUrl: petToy.imageUrl,
                            quantity: _selectedQuantity,
                            type: CartItemType.toy,
                            categoryColor: petToy.getPetTypeColor(),
                            maxQuantity: petToy.stock,
                          );
                          globalCart.addItem(cartItem);

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Added to Cart'),
                              content: Text(
                                '${petToy.name} (Qty: $_selectedQuantity) has been added to your cart',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A6FA5),
                          foregroundColor: Colors.white,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shopping_cart, size: 18),
                            SizedBox(width: 8),
                            Text('Add to Cart'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: _selectedQuantity > 1
                                    ? () {
                                        setState(() {
                                          _selectedQuantity--;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.remove),
                                splashRadius: 20,
                              ),
                              Expanded(
                                child: Text(
                                  '$_selectedQuantity',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _selectedQuantity < petToy.stock
                                    ? () {
                                        setState(() {
                                          _selectedQuantity++;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.add),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Available: ${petToy.stock} items',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (_selectedQuantity > petToy.stock)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Cannot exceed available stock (${petToy.stock})',
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Toy Details
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Info Cards
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            petTypeColor.withOpacity(0.1),
                            petTypeColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: petTypeColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoCard(
                            icon: Icons.pets,
                            title: 'Pet Type',
                            value: petToy.petType,
                            color: petTypeColor,
                          ),
                          _buildInfoCard(
                            icon: Icons.attach_money,
                            title: 'Price',
                            value: '\$${petToy.price.toStringAsFixed(2)}',
                            color: petTypeColor,
                          ),
                          _buildInfoCard(
                            icon: Icons.inventory,
                            title: 'Stock',
                            value: '${petToy.stock} units',
                            color: petTypeColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description Card
                    _buildModernCard(
                      title: 'Description',
                      icon: Icons.description,
                      color: Colors.blue,
                      child: Text(
                        petToy.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF555555),
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Specifications Card
                    _buildModernCard(
                      title: 'Specifications',
                      icon: Icons.settings,
                      color: Colors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSpecRow('Size', petToy.size),
                          _buildSpecRow('Material', petToy.material),
                          _buildSpecRow('Brand', petToy.brand),
                          _buildSpecRow('Manufacturer', petToy.manufacturer),
                          _buildSpecRow(
                            'Age Suitability',
                            petToy.ageSuitability,
                          ),
                          _buildSpecRow('Warranty', petToy.warranty),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Safety & Features Card
                    _buildModernCard(
                      title: 'Safety & Features',
                      icon: Icons.security,
                      color: Colors.orange,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Safety Features:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green[100]!),
                            ),
                            child: Text(
                              petToy.safetyFeatures,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Features:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: petToy.features.map((feature) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 20,
                                      color: Colors.green[500],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF666666),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Cleaning & Care Card
                    _buildModernCard(
                      title: 'Cleaning & Care',
                      icon: Icons.cleaning_services,
                      color: Colors.purple,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.purple[100]!),
                        ),
                        child: Text(
                          petToy.cleaningInstructions,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Quick Facts Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue[100]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[700], size: 30),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quick Facts',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      petToy.isInteractive
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: petToy.isInteractive
                                          ? Colors.green
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Interactive'),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      petToy.isChewResistant
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: petToy.isChewResistant
                                          ? Colors.green
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Chew Resistant'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final cartItem = CartItem(
                                id: 'toy_${petToy.id}',
                                name: petToy.name,
                                price: petToy.price,
                                imageUrl: petToy.imageUrl,
                                quantity: _selectedQuantity,
                                type: CartItemType.toy,
                                categoryColor: petToy.getPetTypeColor(),
                                maxQuantity: petToy.stock,
                              );
                              globalCart.addItem(cartItem);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${petToy.name} (Qty: $_selectedQuantity) added to cart',
                                  ),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      globalCart.removeItem(cartItem.id);
                                    },
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A6FA5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Add to Cart'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF4A6FA5)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.favorite_border),
                            label: const Text('Save for Later'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModernCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
