import 'dart:math';

import 'package:flutter/material.dart';

const double VERTICAL_SWIPE_THRESHOLD = 200;
const int CONTAINER_REVERSE_DURATION = 200;
const double CONTAINER_MIN_OPACITY = 0.6;

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, this.title, this.tag}) : super(key: key);

  final String title;
  final String tag;

  @override
  State<StatefulWidget> createState() => _DetailState();
}

class _DetailState extends State<DetailPage> {
  Offset beginningDragPosition = Offset.zero;
  Offset currentDragPosition = Offset.zero;
  int containerReverseDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(containerBackgroundOpacity),
      child: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: AnimatedContainer(
          duration: Duration(milliseconds: containerReverseDuration),
          transform: containerVerticalTransform,
          child: Hero(
            tag: widget.tag,
            child: Material(
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get containerBackgroundOpacity {
    return max(
        1.0 - currentDragPosition.distance * 0.003, CONTAINER_MIN_OPACITY);
  }

  Matrix4 get containerVerticalTransform {
    final Matrix4 translationTransform = Matrix4.translationValues(
      0,
      currentDragPosition.dy,
      0.0,
    );

    return translationTransform;
  }

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      containerReverseDuration = 0;
    });
    beginningDragPosition = details.globalPosition;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      currentDragPosition = Offset(
        0,
        details.globalPosition.dy - beginningDragPosition.dy,
      );
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (currentDragPosition.distance < VERTICAL_SWIPE_THRESHOLD) {
      setState(() {
        currentDragPosition = Offset.zero;
        containerReverseDuration = CONTAINER_REVERSE_DURATION;
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}
