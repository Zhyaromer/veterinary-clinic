import 'package:flutter/material.dart';
import '../models/pet_toy.dart';

enum _ToyAction { edit, duplicate, delete }

class ToyManagementCard extends StatelessWidget {
  final PetToy toy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  const ToyManagementCard({
    super.key,
    required this.toy,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final petTypeColor = toy.getPetTypeColor();
    final isLowStock = toy.stock < 20;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          children: [
            // Header with Image
            Stack(
              children: [
                // Image
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: petTypeColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      toy.imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            toy.getPetTypeIcon(),
                            size: 50,
                            color: petTypeColor.withOpacity(0.3),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: petTypeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      toy.category,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Interactive Badge
                if (toy.isInteractive)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Interactive',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                // Stock Badge
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isLowStock ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${toy.stock} in stock',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Pet Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          toy.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF222222),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<_ToyAction>(
                        tooltip: 'Actions',
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          switch (value) {
                            case _ToyAction.edit:
                              onEdit();
                              break;
                            case _ToyAction.duplicate:
                              onDuplicate();
                              break;
                            case _ToyAction.delete:
                              onDelete();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: _ToyAction.edit,
                            child: Row(
                              children: const [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: _ToyAction.duplicate,
                            child: Row(
                              children: const [
                                Icon(Icons.content_copy, size: 18),
                                SizedBox(width: 8),
                                Text('Duplicate'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: _ToyAction.delete,
                            child: Row(
                              children: const [
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: petTypeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              toy.getPetTypeIcon(),
                              size: 14,
                              color: petTypeColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              toy.petType,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: petTypeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    toy.description,
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Quick Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Size and Material
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            toy.size,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF222222),
                            ),
                          ),
                          Text(
                            toy.material,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      // Price
                      Text(
                        '\$${toy.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E7D32),
                        ),
                      ),

                      // Age Suitability
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            toy.ageSuitability,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          if (toy.isChewResistant)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Chew Resistant',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Safety Features
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.security,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            toy.safetyFeatures,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Features Preview
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: toy.features.take(3).map((feature) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  // Actions moved to top menu (three dots)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
