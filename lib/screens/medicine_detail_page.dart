// screens/medicine_detail_page.dart
import 'package:flutter/material.dart';
import 'package:vet_clinic/screens/homescreen.dart';
import '../models/medicine.dart';
import '../models/cart_item.dart';

class MedicineDetailPage extends StatefulWidget {
  final Medicine medicine;

  const MedicineDetailPage({super.key, required this.medicine});

  @override
  State<MedicineDetailPage> createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  late int _selectedQuantity;

  @override
  void initState() {
    super.initState();
    _selectedQuantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    final medicine = widget.medicine;
    final categoryColor = medicine.getCategoryColor();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Medicine Image
          SliverAppBar(
            expandedHeight: 400,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Real Image Background
                  Image.network(
                    medicine.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              categoryColor.withOpacity(0.8),
                              categoryColor.withOpacity(0.4),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.medication_liquid,
                            size: 120,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              categoryColor.withOpacity(0.8),
                              categoryColor.withOpacity(0.4),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    },
                  ),

                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            medicine.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
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
                            id: 'medicine_${medicine.id}',
                            name: medicine.name,
                            price: medicine.price,
                            imageUrl: medicine.imageUrl,
                            quantity: _selectedQuantity,
                            type: CartItemType.medicine,
                            categoryColor: medicine.getCategoryColor(),
                            maxQuantity: medicine.stock,
                          );
                          globalCart.addItem(cartItem);

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Added to Cart'),
                              content: Text(
                                '${medicine.name} (Qty: $_selectedQuantity) has been added to your cart',
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
                                onPressed: _selectedQuantity < medicine.stock
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
                    'Available: ${medicine.stock} units',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (_selectedQuantity > medicine.stock)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Cannot exceed available stock (${medicine.stock})',
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Medicine Details
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price and Stock Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '\$${medicine.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Stock',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.inventory,
                                    color: medicine.stock < 20
                                        ? Colors.orange
                                        : Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${medicine.stock} units',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: medicine.stock < 20
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expiry',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    medicine.expiryDate,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Basic Information
                    const Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Form', medicine.form),
                    _buildInfoRow('Route', medicine.route),
                    _buildInfoRow('Animal Type', medicine.animalType),
                    _buildInfoRow('Composition', medicine.composition),
                    _buildInfoRow('Packaging', medicine.packaging),

                    const SizedBox(height: 24),

                    // Indications
                    _buildSection(
                      title: 'Indications',
                      items: medicine.indications,
                      icon: Icons.medical_services,
                      color: Colors.green,
                    ),

                    // Dosage & Administration
                    _buildSection(
                      title: 'Dosage & Administration',
                      content:
                          '${medicine.dosage}\n\n${medicine.administrationInstructions}',
                      icon: Icons.medication,
                      color: Colors.blue,
                    ),

                    // Usage
                    _buildSection(
                      title: 'Usage',
                      content: medicine.usage,
                      icon: Icons.info,
                      color: Colors.orange,
                    ),

                    // Side Effects
                    _buildSection(
                      title: 'Side Effects',
                      items: medicine.sideEffects,
                      icon: Icons.warning,
                      color: Colors.red,
                    ),

                    // Interactions
                    if (medicine.interactions.isNotEmpty)
                      _buildSection(
                        title: 'Drug Interactions',
                        items: medicine.interactions,
                        icon: Icons.link,
                        color: Colors.purple,
                      ),

                    // Contraindications
                    _buildSection(
                      title: 'Contraindications',
                      items: medicine.contraindications,
                      icon: Icons.block,
                      color: Colors.red,
                    ),

                    // Overdose Information
                    _buildSection(
                      title: 'Overdose Information',
                      content: medicine.overdose,
                      icon: Icons.error,
                      color: Colors.redAccent,
                    ),

                    // Handling Precautions
                    _buildSection(
                      title: 'Handling Precautions',
                      content: medicine.handlingPrecautions,
                      icon: Icons.safety_check,
                      color: Colors.amber,
                    ),

                    // Storage Information
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[100]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.storage, color: Colors.blue[700]),
                              const SizedBox(width: 8),
                              const Text(
                                'Storage Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Temperature',
                            medicine.storage.temperature,
                          ),
                          _buildInfoRow(
                            'Light Protection',
                            medicine.storage.lightProtection,
                          ),
                          _buildInfoRow(
                            'After Opening',
                            medicine.storage.afterOpening,
                          ),
                          _buildInfoRow(
                            'Withdrawal Period',
                            medicine.withdrawalPeriod,
                          ),
                        ],
                      ),
                    ),

                    // Manufacturer Information
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[100]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.business, color: Colors.green[700]),
                              const SizedBox(width: 8),
                              const Text(
                                'Manufacturer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Name', medicine.manufacturer.name),
                          _buildInfoRow(
                            'Address',
                            medicine.manufacturer.address,
                          ),
                          _buildInfoRow('Phone', medicine.manufacturer.phone),
                          _buildInfoRow(
                            'Approval No.',
                            medicine.regulatoryApprovalNumber,
                          ),
                          _buildInfoRow('Batch No.', medicine.batchNumber),
                          _buildInfoRow('Barcode', medicine.barcode),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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

  Widget _buildSection({
    required String title,
    List<String>? items,
    String? content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => _buildListItem(item)).toList(),
            )
          else if (content != null)
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF4A6FA5),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
