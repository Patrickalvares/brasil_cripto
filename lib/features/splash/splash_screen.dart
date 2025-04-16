// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../core/common_widgets/welcome_dialog.dart';
import '../home_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double _speedFactor = 2.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _navigateToHome();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() async {
    await WelcomeDialog.showIfNeeded(context);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => const HomeView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/crypto.json',
                controller: _controller,
                width: 250.w,
                height: 250.h,
                fit: BoxFit.contain,
                onLoaded: (composition) {
                  _controller.duration = Duration(
                    milliseconds: (composition.duration.inMilliseconds / _speedFactor).round(),
                  );
                  _controller.forward();
                },
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
              SizedBox(height: 30.h),
              Text(
                'appName'.tr(),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'splash_subtitle'.tr(),
                  style: TextStyle(fontSize: 16.sp, color: Theme.of(context).colorScheme.secondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
