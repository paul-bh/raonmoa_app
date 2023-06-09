import 'package:flutter/material.dart';

/// SECTION - BHTouchEffect
/// 터치할때 들어가는 것 같은 시각적 효과를 주는 기능 세트.
///
/// touch effect wrapper widget.
/// 아무 위젯이나 감싸면 터치 효과를 줄 수 있음.
/// NOTE: 그러나 ListTile과 같은 위젯은 자주 쓰이므로 코드의 간결함을 위해 따로 구현되어 있음.
class BHTouchEffectWrapper extends StatefulWidget {
  final Widget child;
  final Color? $clickedColor;
  final double? $clickedRadius;
  final double? $clickedShrinkRatio;
  final Curve? $clickedCurveColorIn;
  final Curve? $clickedCurveColorOut;
  final Curve? $clickedCurveSizeIn;
  final Curve? $clickedCurveSizeOut;
  final Duration? $clickedDurationIn;
  final Duration? $clickedDurationOut;

  const BHTouchEffectWrapper({
    Key? key,
    required this.child,
    this.$clickedColor,
    this.$clickedRadius,
    this.$clickedShrinkRatio,
    this.$clickedCurveColorIn,
    this.$clickedCurveColorOut,
    this.$clickedCurveSizeIn,
    this.$clickedCurveSizeOut,
    this.$clickedDurationIn,
    this.$clickedDurationOut,
  }) : super(key: key);

  @override
  BHTouchEffectWrapperState createState() => BHTouchEffectWrapperState();
}

class BHTouchEffectWrapperState extends State<BHTouchEffectWrapper> with SingleTickerProviderStateMixin {
  double __scale = 1;
  bool __isClicked = false;
  Color? $clickedColor;
  double? $clickedRadius;
  double? $clickedShrinkRatio;
  Curve? $clickedCurveColorIn;
  Curve? $clickedCurveColorOut;
  Curve? $clickedCurveSizeIn;
  Curve? $clickedCurveSizeOut;
  Duration? $clickedDurationIn;
  Duration? $clickedDurationOut;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color $clickedColor = widget.$clickedColor ?? Colors.grey.withAlpha(50);
    double $clickedRadius = widget.$clickedRadius ?? 0;
    double $clickedShrinkRatio = widget.$clickedShrinkRatio ?? 0.05;
    Curve $clickedCurveColorIn = widget.$clickedCurveColorIn ?? Curves.easeOutCirc;
    Curve $clickedCurveColorOut = widget.$clickedCurveColorOut ?? Curves.easeOutBack;
    Curve $clickedCurveSizeIn = widget.$clickedCurveSizeIn ?? Curves.linear;
    Curve $clickedCurveSizeOut = widget.$clickedCurveSizeOut ?? Curves.easeOutBack;
    Duration $clickedDurationIn = widget.$clickedDurationIn ?? Duration(milliseconds: 100);
    Duration $clickedDurationOut = widget.$clickedDurationOut ?? Duration(milliseconds: 300);

    return GestureDetector(
      onPanEnd: (details) {
        setState(() {
          __scale = 1;
          __isClicked = false;
        });
      },
      onPanDown: (details) {
        setState(() {
          __scale = 1 - $clickedShrinkRatio;
          __isClicked = true;
        });
      },
      onPanCancel: () {
        setState(() {
          __scale = 1;
          __isClicked = false;
        });
      },
      child: AnimatedContainer(
        padding: EdgeInsets.all(0),
        duration: __isClicked ? $clickedDurationIn : $clickedDurationOut,
        curve: __isClicked ? $clickedCurveColorIn : $clickedCurveColorOut,
        decoration: BoxDecoration(
          color: __isClicked ? $clickedColor : $clickedColor.withAlpha(0),
          borderRadius: BorderRadius.circular($clickedRadius),
        ),
        child: AnimatedScale(
          scale: __scale,
          duration: __isClicked ? $clickedDurationIn : $clickedDurationOut,
          curve: __isClicked ? $clickedCurveSizeIn : $clickedCurveSizeOut,
          child: widget.child,
        ),
      ),
    );
  }
}

class BHTouchFXListTile extends ListTile {
  /// Highlight color when tapped.
  final Color? $clickedColor;
  final double? $clickedRadius;
  final double? $clickedShrinkRatio;
  final Curve? $clickedCurveColorIn;
  final Curve? $clickedCurveColorOut;
  final Curve? $clickedCurveSizeIn;
  final Curve? $clickedCurveSizeOut;
  final Duration? $clickedDurationIn;
  final Duration? $clickedDurationOut;
  const BHTouchFXListTile({
    Key? key,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    bool isThreeLine = false,
    bool enabled = true,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    MouseCursor? mouseCursor,
    bool selected = false,
    Color? tileColor,
    Color? focusColor,
    Color? hoverColor,
    Color? selectedTileColor,
    ShapeBorder? shape,
    Clip clipBehavior = Clip.none,
    FocusNode? focusNode,
    bool autofocus = false,
    MaterialTapTargetSize? materialTapTargetSize,
    double? minVerticalPadding,
    bool? enableFeedback,
    EdgeInsetsGeometry? contentPadding,
    this.$clickedColor,
    this.$clickedRadius,
    this.$clickedShrinkRatio,
    this.$clickedCurveColorIn,
    this.$clickedCurveColorOut,
    this.$clickedCurveSizeIn,
    this.$clickedCurveSizeOut,
    this.$clickedDurationIn,
    this.$clickedDurationOut,
  }) : super(
          key: key,
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          isThreeLine: isThreeLine,
          enabled: enabled,
          onTap: onTap,
          onLongPress: onLongPress,
          mouseCursor: mouseCursor,
          selected: selected,
          tileColor: tileColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          selectedTileColor: selectedTileColor,
          shape: shape,
          focusNode: focusNode,
          autofocus: autofocus,
          minVerticalPadding: minVerticalPadding,
          enableFeedback: enableFeedback,
          contentPadding: contentPadding,
        );

  @override
  Widget build(BuildContext context) {
    return BHTouchEffectWrapper(
      $clickedColor: $clickedColor,
      $clickedRadius: $clickedRadius,
      $clickedShrinkRatio: $clickedShrinkRatio,
      $clickedCurveColorIn: $clickedCurveColorIn,
      $clickedCurveColorOut: $clickedCurveColorOut,
      $clickedCurveSizeIn: $clickedCurveSizeIn,
      $clickedCurveSizeOut: $clickedCurveSizeOut,
      $clickedDurationIn: $clickedDurationIn,
      $clickedDurationOut: $clickedDurationOut,
      child: super.build(context),
    );
  }
}

class BHTouchFXInkWell extends InkWell {
  /// Highlight color when tapped.
  final Color? $clickedColor;
  final double? $clickedRadius;
  final double? $clickedShrinkRatio;
  final Curve? $clickedCurveColorIn;
  final Curve? $clickedCurveColorOut;
  final Curve? $clickedCurveSizeIn;
  final Curve? $clickedCurveSizeOut;
  final Duration? $clickedDurationIn;
  final Duration? $clickedDurationOut;
  const BHTouchFXInkWell({
    Widget? child,
    Key? key,
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
    GestureLongPressCallback? onLongPress,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    GestureLongPressUpCallback? onLongPressUp,
    GestureLongPressEndCallback? onLongPressEnd,
    GestureTapDownCallback? onTapDown,
    GestureTapCancelCallback? onTapCancel,
    ValueChanged<bool>? onHighlightChanged,
    ValueChanged<bool>? onHover,
    MouseCursor? mouseCursor,
    InteractiveInkFeatureFactory? splashFactory,
    double? radius,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    bool enableFeedback = true,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Brightness? splashFactoryBrightness,
    InteractiveInkFeatureFactory? highlightFactory,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    VoidCallback? onFocusChange,
    bool autofocus = false,
    MaterialStatesController? statesController,
    this.$clickedColor,
    this.$clickedRadius,
    this.$clickedShrinkRatio,
    this.$clickedCurveColorIn,
    this.$clickedCurveColorOut,
    this.$clickedCurveSizeIn,
    this.$clickedCurveSizeOut,
    this.$clickedDurationIn,
    this.$clickedDurationOut,
  }) : super(
          key: key,
          child: child,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          onTapDown: onTapDown,
          onTapCancel: onTapCancel,
          onHighlightChanged: onHighlightChanged,
          onHover: onHover,
          mouseCursor: mouseCursor,
          splashFactory: splashFactory,
          radius: radius,
          borderRadius: borderRadius,
          customBorder: customBorder,
          enableFeedback: enableFeedback,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          splashColor: splashColor,
          excludeFromSemantics: excludeFromSemantics,
          focusNode: focusNode,
          canRequestFocus: canRequestFocus,
          autofocus: autofocus,
          statesController: statesController,
        );

  @override
  Widget build(BuildContext context) {
    return BHTouchEffectWrapper(
      $clickedColor: $clickedColor,
      $clickedRadius: $clickedRadius,
      $clickedShrinkRatio: $clickedShrinkRatio,
      $clickedCurveColorIn: $clickedCurveColorIn,
      $clickedCurveColorOut: $clickedCurveColorOut,
      $clickedCurveSizeIn: $clickedCurveSizeIn,
      $clickedCurveSizeOut: $clickedCurveSizeOut,
      $clickedDurationIn: $clickedDurationIn,
      $clickedDurationOut: $clickedDurationOut,
      child: super.build(context),
    );
  }
}
