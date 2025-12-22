import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_item.dart';
import '../../../../config/service_locator.dart';
import '../../../../core/services/cache_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingModel> get _items => [
    OnboardingModel(
      title: LocaleKeys.onboarding_title_1.tr(),
      description: LocaleKeys.onboarding_desc_1.tr(),
      image: AppAssets.onboarding1,
    ),
    OnboardingModel(
      title: LocaleKeys.onboarding_title_2.tr(),
      description: LocaleKeys.onboarding_desc_2.tr(),
      image: AppAssets.onboarding2,
    ),
    OnboardingModel(
      title: LocaleKeys.onboarding_title_3.tr(),
      description: LocaleKeys.onboarding_desc_3.tr(),
      image: AppAssets.onboarding3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: TextButton(
                  onPressed: () async {
                    await sl<CacheService>().setOnboardingDone();
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, RouteNames.login);
                  },
                  child: Text(
                    LocaleKeys.skip.tr(),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) =>
                    OnboardingItem(model: _items[index]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  height: 6.h,
                  width: _currentPage == index ? 20.w : 6.w,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? colorScheme.primary
                        : colorScheme.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ElevatedButton(
                onPressed: () async {
                  if (_currentPage < _items.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    
                    await sl<CacheService>().setOnboardingDone();
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, RouteNames.login);
                  }
                },
                child: Text(LocaleKeys.next.tr()),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
