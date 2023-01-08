// ignore_for_file: must_be_immutable

library draggable_resizer;

import 'dart:async';
import 'package:flutter/material.dart';

/// Directions for Dragging in 2-Dimensional Axis
enum Direction { leftToRight, rightToLeft, topToBottom, bottomToTop }

class DraggableResizer extends StatefulWidget {
  /// Direction to drag the widget
  Axis? axis;

  /// Direction in which the drag should start and end
  ///
  /// default of [Axis.horizontal] is [Direction.leftToRight]
  ///
  /// default of [Axis.vertical] is [Direction.bottomToTop]
  Direction? direction;

  /// Initial Size of Draggable Widget
  ///
  /// The size of [feedbackWidget] increases when [draggableWidget] isdragged
  /// You can provide your own [draggableWidget] and [feedbackWidget] to customize that behavior
  double? initialWidgetSize;

  /// The factor at which the draggable widget should increase its size
  double? multiplyFactor;

  /// If you want to allow the rotation property of [draggableWidget] while you are dragging the widget
  bool? shouldDraggableWidgetRotate;

  /// If you want to allow the rotation property of dragging Widget while you are dragging the widget
  bool? shouldDraggingWidgetRotate;

  /// The rotation intensity depends on the size of the widget
  double? rotatingFrame;

  /// This is the widget that shows up when you are dragging the initial widget
  ///
  /// By default it is the number scale from 1 to 100 depending upon the drag value
  bool? showFeedback;

  /// the color of default [draggableWidget] which is [Colors.black] initially
  Color? draggerColor;

  /// the widget you need to show in place of initial widget when dragging
  Widget? widgetWhenDragging;

  /// the main widget that needs to be dragged
  Widget? draggableWidget;

  /// the feedback you need to show when the [draggableWidget] is being dragged
  ///
  /// by default it is the position value from scale of 1 to 100
  Widget? feedbackWidget;

  /// Called whenever the value/position increase while dragging
  ///
  /// from scale of 1 to 100 depends on the [direction] you choose
  Function(double)? onValueChange;

  /// Called when the drag starts
  ///
  /// Returns [initialValue] at the time drag gets started
  Function(double initialValue)? onDragStart;

  /// Called when the draggable is dropped.
  ///
  Function()? onDragEnd;

  /// This function might be called after this widget has been removed from the tree.
  /// For example, if a drag was in progress when this widget was removed from the tree and the drag ended up completing, this callback will still be called. For this reason, implementations of this callback might need to check [State.mounted] to check whether the state receiving the callback is still in the tree
  Function()? onDragComplete;

  /// Called when the draggable is dropped without being accepted by a [DragTarget].
  /// This function might be called after this widget has been removed from the tree. For example, if a drag was in progress when this widget was removed from the tree and the drag ended up being canceled, this callback will still be called. For this reason, implementations of this callback might need to check [State.mounted] to check whether the state receiving the callback is still in the tree.
  Function(Velocity, Offset)? onDragCancelled;

  DraggableResizer(
      {Key? key,
      this.axis = Axis.horizontal,
      this.direction,
      this.draggerColor = Colors.black,
      this.rotatingFrame = 15.0,
      this.initialWidgetSize = 20.0,
      this.multiplyFactor = 14.0,
      this.showFeedback = true,
      this.shouldDraggableWidgetRotate = true,
      this.shouldDraggingWidgetRotate = true,
      this.feedbackWidget,
      this.widgetWhenDragging,
      this.draggableWidget,
      this.onValueChange,
      this.onDragStart,
      this.onDragEnd,
      this.onDragComplete,
      this.onDragCancelled})
      : super(key: key) {
    if (axis == Axis.vertical && direction == null) {
      direction = Direction.bottomToTop;
    }
    if (axis == Axis.horizontal && direction == null) {
      direction = Direction.leftToRight;
    }
    if ((direction != null && axis != null) &&
        axis == Axis.horizontal &&
        (direction == Direction.topToBottom ||
            direction == Direction.bottomToTop)) {
      throw "Vertical Direction is not valid for Horizontal Axis.";
    }
    if ((direction != null && axis != null) &&
        axis == Axis.vertical &&
        (direction == Direction.rightToLeft ||
            direction == Direction.leftToRight)) {
      throw "Horizontal Direction is not valid for Vertical Axis.";
    }
  }
  @override
  State<DraggableResizer> createState() => _DraggableResizerState();
}

class _DraggableResizerState extends State<DraggableResizer> {
  /// value changes is broadcasted through this stream controller
  var streamController = StreamController<double>.broadcast();

  double widgetSize = 20.0;
  double msize = 50.0;

  // Max value a dragged can scale to
  double maxRange = 100.0;
  double screenRelativePosition = 0.0;

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable(
      axis: widget.axis ?? Axis.horizontal,
      onDragEnd: ((details) =>
          widget.onDragEnd == null ? null : widget.onDragEnd!),
      onDragCompleted: (() =>
          widget.onDragComplete == null ? null : widget.onDragComplete!),
      onDraggableCanceled: (((velocity, offset) {
        widget.onDragCancelled == null
            ? null
            : widget.onDragCancelled!(velocity, offset);
      })),
      onDragStarted: () =>
          widget.onDragStart == null ? null : widget.onDragStart!(msize),
      onDragUpdate: (details) {
        setState(() {
          widgetSize = widget.initialWidgetSize!;

          screenRelativePosition = widget.axis != null &&
                  widget.axis == Axis.vertical
              ? (details.globalPosition.dy / MediaQuery.of(context).size.height)
              : (details.globalPosition.dx / MediaQuery.of(context).size.width);

          widgetSize += widget.direction != null &&
                  widget.direction == Direction.leftToRight
              ? ((screenRelativePosition) * widget.multiplyFactor!)
              : ((1.0 - screenRelativePosition) * widget.multiplyFactor!);

          if (msize > maxRange) msize = maxRange;
          msize = ((widgetSize - widget.initialWidgetSize!) /
                  widget.multiplyFactor!) *
              maxRange;

          if (msize < 0) msize = 0.0;
          streamController.add(msize);

          widget.onValueChange == null ? () {} : widget.onValueChange!(msize);
        });
      },
      feedback: widget.showFeedback != null && widget.showFeedback == true
          ? widget.feedbackWidget ??
              StreamBuilder(
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? _feedBack(snapshot.data!.toStringAsFixed(2))
                        : snapshot.hasError
                            ? Material(child: Text(snapshot.error.toString()))
                            : const SizedBox();
                  })
          : const SizedBox(),
      childWhenDragging: _component(),
      child: _component(),
    );
  }

  /// The defult widget as [draggableWidget] and [draggingWidget]
  _component() => widget.shouldDraggingWidgetRotate != null &&
          widget.shouldDraggingWidgetRotate == true
      ? Transform.rotate(
          angle: msize / widget.rotatingFrame!,
          child: widget.widgetWhenDragging ?? _circle())
      : widget.widgetWhenDragging ?? _circle();

  _circle() => Container(
      height: widgetSize,
      width: widgetSize,
      decoration: BoxDecoration(
        color: widget.draggerColor,
        shape: BoxShape.circle,
      ));

  /// Feedback while the [draggableWidget] is being dragged
  _feedBack(String data) => Material(
        color: Colors.transparent,
        child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(14)),
            child: Text(
              data,
              style: TextStyle(color: Theme.of(context).cardColor),
            )),
      );
}
