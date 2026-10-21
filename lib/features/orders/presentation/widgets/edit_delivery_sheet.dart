import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../providers/delivery_info_provider.dart';

Future<void> showEditDeliveryBottomSheet({
  required BuildContext context,
  required DeliveryInfo currentInfo,
  required void Function(DeliveryInfo updatedInfo) onSave,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _EditDeliveryModal(
        initialInfo: currentInfo,
        onSave: onSave,
      );
    },
  );
}

class _EditDeliveryModal extends StatefulWidget {
  final DeliveryInfo initialInfo;
  final void Function(DeliveryInfo updatedInfo) onSave;

  const _EditDeliveryModal({
    required this.initialInfo,
    required this.onSave,
  });

  @override
  State<_EditDeliveryModal> createState() => _EditDeliveryModalState();
}

class _EditDeliveryModalState extends State<_EditDeliveryModal> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController(text: widget.initialInfo.street);
    _cityController = TextEditingController(text: widget.initialInfo.city);
    _stateController = TextEditingController(text: widget.initialInfo.state);
    _pincodeController = TextEditingController(text: widget.initialInfo.pincode);
    _phoneController = TextEditingController(text: widget.initialInfo.phone);
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final updated = DeliveryInfo(
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        phone: _phoneController.text.replaceAll(RegExp(r'\D'), '').trim(),
      );

      widget.onSave(updated);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delivery address & contact updated successfully!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Delivery Address & Contact',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Street Address
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Address, Flat / House No.',
                  hintText: 'e.g. Flat 402, Green Glen Layout, Bellandur',
                  prefixIcon: Icon(Icons.home_outlined, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter street address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // City & State Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        hintText: 'e.g. Bengaluru',
                        prefixIcon: Icon(Icons.location_city_outlined, size: 20),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        hintText: 'e.g. Karnataka',
                        prefixIcon: Icon(Icons.map_outlined, size: 20),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Pincode & Contact Phone Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Pincode (6-digit)',
                        hintText: '560103',
                        counterText: '',
                        prefixIcon: Icon(Icons.pin_drop_outlined, size: 20),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().length != 6) {
                          return 'Enter 6 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number (10-digit)',
                        hintText: '9876543210',
                        counterText: '',
                        prefixIcon: Padding(
                          padding: EdgeInsets.fromLTRB(12, 14, 4, 14),
                          child: Text('+91', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ),
                      validator: (val) {
                        final digits = val?.replaceAll(RegExp(r'\D'), '') ?? '';
                        if (digits.length != 10) {
                          return 'Enter 10-digit mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Primary Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary, // Electric Cyan (#00A6FF)
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save & Update Address',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
