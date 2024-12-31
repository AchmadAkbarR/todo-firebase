import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 24),
                      _buildDescription(),
                      const SizedBox(height: 48),
                      _buildTechnologies(),
                      const SizedBox(height: 48),
                      _buildFeatures(),
                      const SizedBox(height: 64),
                      _buildStartButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: BackgroundPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
      ).createShader(bounds),
      child: Text(
        "Todolist Pro",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      "Tingkatkan produktivitas Anda dengan solusi manajemen tugas yang intuitif.",
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: Colors.white.withOpacity(0.9),
        height: 1.5,
      ),
    );
  }

  Widget _buildTechnologies() {
    return Column(
      children: [
        Text(
          "Ditenagai oleh teknologi terkini",
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTechLogo('assets/flutter_logo.svg'),
            const SizedBox(width: 32),
            _buildTechLogo('assets/firebase_logo.svg'),
            const SizedBox(width: 32),
            _buildTechLogo('assets/flutter_logo.svg'),
          ],
        ),
      ],
    );
  }

  Widget _buildTechLogo(String assetName) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SvgPicture.asset(
        assetName,
        width: 48,
        height: 48,
      ),
    );
  }

  Widget _buildFeatures() {
    return Column(
      children: [
        Text(
          "Fitur Utama",
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        _buildFeatureItem(Icons.check_circle_outline, "Manajemen tugas yang mudah"),
        _buildFeatureItem(Icons.update, "Sinkronisasi waktu nyata"),
        _buildFeatureItem(Icons.brush, "Antarmuka yang menarik dan intuitif"),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/todoPage');
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Text(
        "Mulai Sekarang",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6A11CB),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    for (var i = 0; i < size.width; i++) {
      path.lineTo(
        i.toDouble(),
        size.height / 2 +
            math.sin((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * 50,
      );
    }

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
