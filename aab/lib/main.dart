import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Drawing App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];
  bool isDrawingLocked = false; // Variable to track if drawing is locked

  void _clearDrawing() {
    setState(() {
      points.clear(); // Clear the drawing
    });
  }

  void _toggleDrawingLock(bool value) {
    setState(() {
      isDrawingLocked = value; // Toggle the drawing lock
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        isDrawingLocked ? 'Drawing Locked' : 'Drawing Unlocked',
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              if (!isDrawingLocked) {
                setState(() {
                  points.add(details.localPosition); // Add points for drawing
                });
              }
            },
            onPanEnd: (details) {
              if (!isDrawingLocked) {
                points.add(null); // Add null to create a break in the line
              }
            },
            child: CustomPaint(
              painter: DrawingPainter(points),
              child: Container(),
            ),
          ),
          // Display the "Tak-Rang" text as background
          Center(
            child: Opacity(
              opacity: 0.05, // Low opacity for background text
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05, // Bottom padding based on screen size
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth * 0.05), // Responsive horizontal padding
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Space between buttons
                children: [
                  // Lock/Unlock Drawing Switch
                  Row(
                    children: [
                      Text(
                        isDrawingLocked ? "Unlock Drawing" : "Lock Drawing",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, // Responsive font size
                        ),
                      ),
                      Switch(
                        value: isDrawingLocked,
                        onChanged: _toggleDrawingLock,
                      ),
                    ],
                  ),
                  // Clear Button
                  GestureDetector(
                    onDoubleTap: _clearDrawing, // Clear on double tap
                    child: Container(
                      width: screenWidth * 0.4, // Responsive button width
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02), // Responsive padding
                      child: Center(
                        child: Text(
                          "Double Tap to Clear",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                screenWidth * 0.04, // Responsive text size
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i]!, points[i + 1]!, paint); // Draw lines between points
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever points change
  }
}
