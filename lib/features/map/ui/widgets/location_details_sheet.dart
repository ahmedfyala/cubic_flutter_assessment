import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/notifier.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../data/models/location_model.dart';

class LocationDetailsSheet extends StatefulWidget {
  final LocationModel location;
  final bool initialIsFavorite;
  final Future<bool> Function() onAdd;
  final Future<bool> Function() onRemove;

  const LocationDetailsSheet({
    super.key,
    required this.location,
    required this.initialIsFavorite,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<LocationDetailsSheet> createState() => _LocationDetailsSheetState();
}

class _LocationDetailsSheetState extends State<LocationDetailsSheet> {
  late bool _isFavorite;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.all(12.r),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  widget.location.type == 'BRANCH'
                      ? Icons.account_balance
                      : Icons.atm,
                  color: colorScheme.primary,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.location.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      widget.location.type,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildInfoSection(
            Icons.location_on_outlined,
            'Address',
            widget.location.address,
          ),
          if (widget.location.workingHours != null) ...[
            SizedBox(height: 16.h),
            _buildInfoSection(
              Icons.access_time,
              'Working Hours',
              widget.location.workingHours!,
            ),
          ],
          if (widget.location.services != null &&
              widget.location.services!.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Text(
              'Services',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: widget.location.services!
                  .map((s) => _buildServiceChip(s, colorScheme))
                  .toList(),
            ),
          ],
          SizedBox(height: 30.h),
          CustomElevatedButton(
            isLoading: _isLoading,
            color: _isFavorite ? Colors.redAccent : colorScheme.primary,
            text: _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    final success = _isFavorite
                        ? await widget.onRemove()
                        : await widget.onAdd();
                    if (!mounted) return;
                    if (success) {
                      setState(() {
                        _isFavorite = !_isFavorite;
                        _isLoading = false;
                      });
                      Notifier.show(
                        context: context,
                        message: _isFavorite
                            ? 'Added to favorites successfully'
                            : 'Removed from favorites',
                        type: NotificationType.toast,
                      );
                      Navigator.pop(context);
                    } else {
                      setState(() => _isLoading = false);
                      Notifier.show(
                        context: context,
                        message: 'Operation failed',
                        type: NotificationType.toast,
                      );
                    }
                  },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildInfoSection(IconData icon, String title, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: colorScheme.outline),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 11.sp, color: colorScheme.outline),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceChip(String label, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
