import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tak-rang Drawing App',
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
  Color currentColor = Colors.red;

  void _clearDrawing() {
    setState(() {
      points.clear(); // Clear the drawing
    });
  }

  void _changeColor(Color color) {
    setState(() {
      currentColor = color; // Change the drawing color
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition); // Add points for drawing
              });
            },
            onPanEnd: (details) {
              points.add(null); // Add null to create a break in the line
            },
            child: CustomPaint(
              painter: DrawingPainter(points, currentColor),
              child: Container(),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Opacity(
                      opacity: 1.0, // Set opacity to 30%
                      child: FloatingActionButton(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Rounded edges
                        ),
                        backgroundColor: currentColor,
                        onPressed: _clearDrawing,
                        child: Icon(Icons.delete,
                            color: Colors.green), // Change icon color to green
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded edges
                      ),
                      backgroundColor: currentColor,
                      onPressed: () {
                        // Change color to red, blue, or black randomly
                        _changeColor(
                          currentColor == Colors.red
                              ? Colors.blue
                              : (currentColor == Colors.blue
                                  ? Colors.black
                                  : Colors.red),
                        );
                      },
                      child: Icon(Icons.palette,
                          color: Colors.green), // Change icon color to green
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;

  DrawingPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Use the current drawing color
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
