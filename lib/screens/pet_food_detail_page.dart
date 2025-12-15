import 'package:flutter/material.dart';
import '../models/pet_food.dart';
import '../models/cart_item.dart';
import '../main.dart';

class PetFoodDetailPage extends StatefulWidget {
  final PetFood petFood;

  const PetFoodDetailPage({super.key, required this.petFood});

  @override
  State<PetFoodDetailPage> createState() => _PetFoodDetailPageState();
}

class _PetFoodDetailPageState extends State<PetFoodDetailPage> {
  late int _selectedQuantity;

  @override
  void initState() {
    super.initState();
    _selectedQuantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    final petFood = widget.petFood;
    final petTypeColor = petFood.getPetTypeColor();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 400,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Food Image
                  Hero(
                    tag: 'food-${petFood.id}',
                    child: Image.network(
                      petFood.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: petTypeColor.withOpacity(0.1),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  petFood.getPetTypeIcon(),
                                  size: 80,
                                  color: petTypeColor.withOpacity(0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  petFood.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: petTypeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Content Overlay
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: petTypeColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            petFood.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          petFood.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(blurRadius: 8, color: Colors.black54),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          petFood.flavor,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {},
              ),
            ],
          ),

          // Quantity Section with Add to Cart
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
                            id: 'food_${petFood.id}',
                            name: petFood.name,
                            price: petFood.price,
                            imageUrl: petFood.imageUrl,
                            quantity: _selectedQuantity,
                            type: CartItemType.food,
                            categoryColor: petFood.getPetTypeColor(),
                            maxQuantity: petFood.stock,
                          );
                          globalCart.addItem(cartItem);

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Added to Cart'),
                              content: Text(
                                '${petFood.name} (Qty: $_selectedQuantity) has been added to your cart',
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
                                onPressed: _selectedQuantity < petFood.stock
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
                    'Available: ${petFood.stock} items',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (_selectedQuantity > petFood.stock)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Cannot exceed available stock (${petFood.stock})',
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Food Details
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Info Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price
                              _buildInfoBox(
                                icon: Icons.attach_money,
                                title: 'Price',
                                value: '\$${petFood.price.toStringAsFixed(2)}',
                                subtitle: petFood.size,
                                color: const Color(0xFF4CAF50),
                              ),
                              // Stock
                              _buildInfoBox(
                                icon: Icons.inventory,
                                title: 'Stock',
                                value: '${petFood.stock} units',
                                subtitle: petFood.stock < 20
                                    ? 'Low Stock'
                                    : 'In Stock',
                                color: petFood.stock < 20
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                              // Expiry
                              _buildInfoBox(
                                icon: Icons.calendar_today,
                                title: 'Expires',
                                value: petFood.expiryDate,
                                subtitle: 'Best Before',
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Additional Info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMiniChip(
                                icon: Icons.pets,
                                label: petFood.petType,
                                color: petTypeColor,
                              ),
                              _buildMiniChip(
                                icon: Icons.timeline,
                                label: petFood.lifeStage,
                                color: Colors.purple,
                              ),
                              if (petFood.isGrainFree)
                                _buildMiniChip(
                                  icon: Icons.grain,
                                  label: 'Grain-Free',
                                  color: Colors.green,
                                ),
                              if (petFood.isOrganic)
                                _buildMiniChip(
                                  icon: Icons.spa,
                                  label: 'Organic',
                                  color: Colors.teal,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Description
                    _buildSection(
                      title: 'Description',
                      icon: Icons.description,
                      color: Colors.blue,
                      child: Text(
                        petFood.description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF555555),
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Key Nutrients
                    _buildSection(
                      title: 'Key Nutrients',
                      icon: Icons.food_bank,
                      color: Colors.orange,
                      child: Column(
                        children: petFood.keyNutrients.map((nutrient) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    nutrient,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Ingredients
                    _buildSection(
                      title: 'Ingredients',
                      icon: Icons.list,
                      color: Colors.purple,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: petFood.ingredients.map((ingredient) {
                          return Chip(
                            label: Text(
                              ingredient,
                              style: const TextStyle(fontSize: 13),
                            ),
                            backgroundColor: Colors.grey[100],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Feeding Guidelines
                    _buildSection(
                      title: 'Feeding Guidelines',
                      icon: Icons.restaurant,
                      color: Colors.green,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[100]!),
                        ),
                        child: Text(
                          petFood.feedingGuidelines,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF555555),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Storage Information
                    _buildSection(
                      title: 'Storage & Shelf Life',
                      icon: Icons.storage,
                      color: Colors.brown,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.brown[100]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              petFood.storageInstructions,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF555555),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(color: Colors.brown[200]),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.warning,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Use before: ${petFood.expiryDate}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF795548),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Brand & Manufacturer
                    _buildSection(
                      title: 'Brand Information',
                      icon: Icons.business,
                      color: Colors.indigo,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.indigo[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigo[100]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Brand', petFood.brand),
                            _buildInfoRow('Manufacturer', petFood.manufacturer),
                            _buildInfoRow(
                              'Nutritional Guarantee',
                              petFood.nutritionalGuarantee,
                            ),
                            if (petFood.isPrescriptionRequired)
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.medical_services,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        'Prescription Required',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Action Buttons
                    Row(
                      children: [
                        // Wishlist Button
                        Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border,
                              size: 28,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMiniChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
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
                fontSize: 14,
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
