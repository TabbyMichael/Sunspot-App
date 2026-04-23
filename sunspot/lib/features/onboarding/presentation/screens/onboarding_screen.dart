import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sunspot/core/theme/app_colors.dart';
import 'package:sunspot/shared/widgets/buttons/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  final Future<void> Function() onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      title: 'Welcome to Sunspot',
      description:
          'Your journey to clean, sustainable solar energy starts here. Discover the power of the sun.',
      icon: Icons.solar_power,
      color: const Color(0xFFF59E0B),
    ),
    OnboardingSlide(
      title: 'Track Your Solar',
      description:
          'Monitor your solar installations, track savings, and manage your energy consumption all in one place.',
      icon: Icons.analytics,
      color: const Color(0xFF10B981),
    ),
    OnboardingSlide(
      title: 'Shop Solar Products',
      description:
          'Browse and purchase high-quality solar equipment for your home or business.',
      icon: Icons.shopping_bag,
      color: const Color(0xFF3B82F6),
    ),
    OnboardingSlide(
      title: 'Get Started',
      description:
          'Sign in or create an account to start your solar journey today.',
      icon: Icons.rocket_launch,
      color: const Color(0xFF8B5CF6),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    try {
      await widget.onComplete();
    } catch (e) {
      print('Error saving onboarding status: $e');
    }
    if (mounted) {
      context.go('/login');
    }
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipToLastSlide() {
    final lastSlideIndex = _slides.length - 1;
    if (_currentPage < lastSlideIndex) {
      _pageController.animateToPage(
        lastSlideIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildSlide(_slides[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: slide.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 100, color: slide.color),
          ),
          const SizedBox(height: 48),
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            slide.description,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => _buildPageIndicator(index == _currentPage),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: _currentPage == _slides.length - 1 ? 'Get Started' : 'Next',
            onPressed: _nextPage,
          ),
          const SizedBox(height: 16),
          if (_currentPage < _slides.length - 1)
            TextButton(
              onPressed: _skipToLastSlide,
              child: Text(
                'Skip',
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.textMuted.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingSlide {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
