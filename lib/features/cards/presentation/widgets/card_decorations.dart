import 'dart:math' as math;
import 'package:flutter/material.dart';

class ContactlessIcon extends StatelessWidget {
  final Color color;
  final double size;

  const ContactlessIcon({
    super.key,
    this.color = Colors.white,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ContactlessPainter(color),
    );
  }
}

class _ContactlessPainter extends CustomPainter {
  final Color color;

  _ContactlessPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width * 0.1, size.height * 0.5);

    for (int i = 1; i <= 3; i++) {
      final radius = (size.width * 0.28) * i;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 4,
        math.pi / 2,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BankLogoWidget extends StatelessWidget {
  final String bankName;
  final double size;

  const BankLogoWidget({
    super.key,
    required this.bankName,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    final upper = bankName.toUpperCase();

    // 1. HDFC Bank
    if (upper.contains('HDFC')) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFED1C24), // HDFC Red
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Container(
            width: size * 0.55,
            height: size * 0.55,
            decoration: BoxDecoration(
              color: const Color(0xFF004C8F), // HDFC Blue
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      );
    }
    // 2. SBI (State Bank of India)
    else if (upper.contains('SBI') || upper.contains('STATE BANK')) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFF280071), // SBI Blue
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: size * 0.45,
            height: size * 0.45,
            decoration: const BoxDecoration(
              color: Color(0xFF00A3E0),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
    // 3. ICICI & Amazon Pay ICICI
    else if (upper.contains('AMAZON')) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF131921), // Amazon Black
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFFF9900), width: 1),
        ),
        child: const Center(
          child: Text(
            'a',
            style: TextStyle(
              color: Color(0xFFFF9900),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else if (upper.contains('ICICI')) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Color(0xFFF37021), // ICICI Orange
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            'i',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }
    // 4. RBL Bank
    else if (upper.contains('RBL')) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF00338D), // RBL Blue
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Center(
          child: Text(
            'RBL',
            style: TextStyle(
              color: Color(0xFFFF6600), // RBL Orange
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: -0.5,
            ),
          ),
        ),
      );
    }
    // 5. Canara Bank
    else if (upper.contains('CANARA')) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF005697), // Canara Blue
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFFFCC00), width: 1.2), // Canara Gold
        ),
        child: const Center(
          child: Text(
            'CB',
            style: TextStyle(
              color: Color(0xFFFFCC00),
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ),
      );
    }
    // 6. Slice Card
    else if (upper.contains('SLICE')) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6), // Slice Purple
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            '//',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ),
      );
    }
    // 7. Indian Overseas Bank (IOB)
    else if (upper.contains('IOB') || upper.contains('OVERSEAS')) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF002D62), // IOB Deep Blue
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFD700), width: 1.5), // IOB Gold
        ),
        child: const Center(
          child: Text(
            'IOB',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 9,
            ),
          ),
        ),
      );
    }

    // Default Bank Badge
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Center(
        child: Icon(Icons.account_balance, color: Colors.white, size: 16),
      ),
    );
  }
}

class NetworkLogoWidget extends StatelessWidget {
  final String network;

  const NetworkLogoWidget({super.key, required this.network});

  @override
  Widget build(BuildContext context) {
    final upper = network.toUpperCase();

    if (upper.contains('VISA')) {
      return const Text(
        'VISA',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          fontSize: 20,
          letterSpacing: 1.5,
        ),
      );
    } else if (upper.contains('MASTER')) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Color(0xFFEB001B),
              shape: BoxShape.circle,
            ),
          ),
          Transform.translate(
            offset: const Offset(-6, 0),
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFFF79E1B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else if (upper.contains('RUPAY')) {
      return const Text(
        'RuPay',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: 16,
        ),
      );
    }

    return Text(
      network,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}
