import 'package:flutter/material.dart';
import '../models/medicine.dart';

enum _MedicineAction { edit, duplicate, delete }

class MedicineManagementCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onResetStock;

  const MedicineManagementCard({
    super.key,
    required this.medicine,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
    required this.onResetStock,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = medicine.getCategoryColor();
    final isLowStock = medicine.stock < 20;
    final isExpiringSoon = _isExpiringSoon(medicine.expiryDate);

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
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GestureDetector(
                        onTap: () {
                          _openImagePreview(context, medicine.imageUrl);
                        },
                        child: Hero(
                          tag: medicine.imageUrl,
                          child: Image.network(
                            medicine.imageUrl,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  medicine.getAnimalIcon(),
                                  size: 30,
                                  color: categoryColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Medicine Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                medicine.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF222222),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<_MedicineAction>(
                              tooltip: 'Actions',
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                switch (value) {
                                  case _MedicineAction.edit:
                                    onEdit();
                                    break;
                                  case _MedicineAction.duplicate:
                                    onDuplicate();
                                    break;
                                  case _MedicineAction.delete:
                                    onDelete();
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: _MedicineAction.edit,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.edit, size: 18),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: _MedicineAction.duplicate,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.content_copy, size: 18),
                                      SizedBox(width: 8),
                                      Text('Duplicate'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: _MedicineAction.delete,
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.red,
                                      ),
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
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                medicine.category,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: categoryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              medicine.animalType,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_offer,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '\$${medicine.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stock and Expiry Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stock
                      _buildDetailItem(
                        icon: Icons.inventory,
                        label: 'Stock',
                        value: '${medicine.stock} units',
                        isWarning: isLowStock,
                      ),

                      // Expiry
                      _buildDetailItem(
                        icon: Icons.calendar_today,
                        label: 'Expiry',
                        value: medicine.expiryDate,
                        isWarning: isExpiringSoon,
                      ),

                      // Batch
                      _buildDetailItem(
                        icon: Icons.qr_code,
                        label: 'Batch',
                        value: medicine.batchNumber,
                        isWarning: false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Manufacturer and Barcode
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: _buildDetailItem(
                          icon: Icons.business,
                          label: 'Manufacturer',
                          value: medicine.manufacturer.name,
                          isWarning: false,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        child: _buildDetailItem(
                          icon: Icons.barcode_reader,
                          label: 'Barcode',
                          value: medicine.barcode,
                          isWarning: false,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isWarning,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isWarning ? Colors.orange : const Color(0xFF222222),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  bool _isExpiringSoon(String expiryDate) {
    try {
      final expiry = DateTime.parse(expiryDate);
      final today = DateTime.now();
      final difference = expiry.difference(today).inDays;
      return difference <= 90; // Expiring in 3 months or less
    } catch (e) {
      return false;
    }
  }
}

void _openImagePreview(BuildContext context, String imageUrl) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.9),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, _, _) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.network(imageUrl, fit: BoxFit.fill),
            ),
          ),
        ),
      );
    },
  );
}
