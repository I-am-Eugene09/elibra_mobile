import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomLoadingModal extends StatelessWidget {
  final String message;

  const CustomLoadingModal({super.key, this.message = "Loading please wait..."});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 250,
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/images/Logo.svg", 
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                DotIndicator(color: Colors.green),
                SizedBox(width: 8),
                DotIndicator(color: Colors.greenAccent),
                SizedBox(width: 8),
                DotIndicator(color: Colors.lightGreen),
              ],
            ),
          ],
        ),
      ),
      )
    );
  }
}

class DotIndicator extends StatefulWidget {
  final Color color;

  const DotIndicator({super.key, required this.color});

  @override
  State<DotIndicator> createState() => _DotIndicatorState();
} 

class _DotIndicatorState extends State<DotIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}


