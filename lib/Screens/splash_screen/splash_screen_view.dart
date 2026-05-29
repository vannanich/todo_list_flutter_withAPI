import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio_todo_llist/Screens/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _dotController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<double> _dotScale;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text animation
    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1700),
    );
    _textSlide = Tween<Offset>(
      begin: Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    // Tagline animation
    _taglineController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    _dotController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _dotScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.easeInOut),
    );
  }

  void _startSequence() async {
  await Future.delayed(Duration(milliseconds: 300));
  _logoController.forward();

  await Future.delayed(Duration(milliseconds: 600));
  _textController.forward();

  await Future.delayed(Duration(milliseconds: 400));
  _taglineController.forward();

  await Future.delayed(Duration(milliseconds: 3000)); 
  _navigate();
}

  void _navigate() {
    final box = GetStorage();
    final token = box.read("token");
    debugPrint("token on splash: $token"); 
    if (token != null && token.toString().isNotEmpty) {
      Get.offAllNamed(AppRoutes.home); 
    } else {
      Get.offAllNamed(AppRoutes.login); 
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // ── Background geometric decoration ──
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
              ),
            ),
          ),
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
              ),
            ),
          ),

          // ── Main Content ──
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // ── Logo ──
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.15),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image(
                      image: AssetImage("assets/Vector.png"), // ← put your image name here
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "NOTO",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 6,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // ── Tagline ──
                AnimatedBuilder(
                  animation: _taglineController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _taglineOpacity,
                      child: child,
                    );
                  },
                  child: Text(
                    "Manage your tasks, master your day.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white38,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Loading dots at bottom ──
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _taglineController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _taglineOpacity,
                  child: child,
                );
              },
              child: AnimatedBuilder(
                animation: _dotController,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _dotController,
                        builder: (context, _) {
                          final delay = index * 0.2;
                          final value = ((_dotController.value + delay) % 1.0);
                          final scale = 0.5 + (value < 0.5 ? value : 1.0 - value);
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(scale),
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}