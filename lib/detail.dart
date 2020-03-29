import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:listtransition/dummy.dart';

const double VERTICAL_SWIPE_THRESHOLD = 200;
const int CONTAINER_REVERSE_DURATION = 200;
const double CONTAINER_MIN_OPACITY = 0.3;

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, this.title, this.tag}) : super(key: key);

  final String title;
  final String tag;

  @override
  State<StatefulWidget> createState() => _DetailState();
}

class _DetailState extends State<DetailPage> {
  final ScrollController _scrollController = ScrollController();

  Offset beginningDragPosition = Offset.zero;
  Offset currentDragPosition = Offset.zero;
  int containerReverseDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(containerBackgroundOpacity),
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUpEvent,
        child: AnimatedContainer(
          duration: Duration(milliseconds: containerReverseDuration),
          transform: containerVerticalTransform,
          child: Hero(
            tag: widget.tag,
            child: Material(
              color: Colors.blueGrey,
              child: ListView(
                controller: _scrollController,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 24.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Text(
                      DUMMY_TEXT,
                      style:
                      const TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get containerBackgroundOpacity {
    return max(
        1.0 - currentDragPosition.distance * 0.0015, CONTAINER_MIN_OPACITY);
  }

  Matrix4 get containerVerticalTransform {
    final Matrix4 translationTransform = Matrix4.translationValues(
      0,
      currentDragPosition.dy,
      0.0,
    );

    return translationTransform;
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      containerReverseDuration = 0;
    });
    beginningDragPosition = event.position;
  }

  void _onPointerMove(PointerMoveEvent event) {
    final ScrollDirection direction =
        _scrollController.position.userScrollDirection;
    if ((direction != ScrollDirection.reverse ||
        _scrollController.position.maxScrollExtent >
            _scrollController.position.pixels) &&
        (direction != ScrollDirection.forward ||
            _scrollController.offset > 0)) {
      return;
    }

    setState(() {
      currentDragPosition = Offset(
        0,
        event.position.dy - beginningDragPosition.dy,
      );
    });
  }

  void _onPointerUpEvent(PointerUpEvent event) {
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
