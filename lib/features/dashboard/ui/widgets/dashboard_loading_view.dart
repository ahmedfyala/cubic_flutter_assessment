import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80.w, height: 12.h, color: Colors.grey),
                    SizedBox(height: 8.h),
                    Container(width: 120.w, height: 20.h, color: Colors.grey),
                  ],
                ),
                Container(
                  width: 45.r,
                  height: 45.r,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            Center(
              child: Column(
                children: [
                  Container(width: 100.w, height: 12.h, color: Colors.grey),
                  SizedBox(height: 12.h),
                  Container(width: 180.w, height: 32.h, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 120.w, height: 18.h, color: Colors.grey),
                Container(width: 50.w, height: 14.h, color: Colors.grey),
              ],
            ),
            SizedBox(height: 16.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (_, __) => Row(
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100.w,
                          height: 14.h,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 60.w,
                          height: 10.h,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Container(width: 60.w, height: 16.h, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
