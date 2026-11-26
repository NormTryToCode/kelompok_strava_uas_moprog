import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/photo_crop_overlay.dart';

enum _CropDragMode {
  none,
  move,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  bottom,
  left,
  right,
}

class ProfilePhotoCropScreen extends StatefulWidget {
  final File imageFile;

  const ProfilePhotoCropScreen({super.key, required this.imageFile});

  @override
  State<ProfilePhotoCropScreen> createState() => _ProfilePhotoCropScreenState();
}

class _ProfilePhotoCropScreenState extends State<ProfilePhotoCropScreen>
  with SingleTickerProviderStateMixin {
    ui.Image? _decodedImage;

  Rect _initialImageRect = Rect.zero;
  Rect _imageRect = Rect.zero;
  Rect _baseCropRect = Rect.zero;
  Rect? _cropRect;
  Rect _dragStartCropRect = Rect.zero;
  Size _lastViewportSize = Size.zero;

  _CropDragMode _dragMode = _CropDragMode.none;
  bool _isCropping = false;

  late final AnimationController _snapController;
  Rect _animStartImageRect = Rect.zero;
  Rect _animEndImageRect = Rect.zero;
  Rect _animStartCropRect = Rect.zero;

  static const double _cornerHitRadius = 34.0;
  static const double _edgeHitTolerance = 24.0;
  static const double _minCropSize = 72.0;
  static const double _screenOuterMargin = 14.0;
  static const double _maxZoomFactor = 6.0;
  static const double _resizeThreshold = 6.0;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    )..addListener(_onSnapAnimationTick);

    _loadImage();
  }

  @override
  void dispose() {
    _snapController.removeListener(_onSnapAnimationTick);
    _snapController.dispose();
    _decodedImage?.dispose();
    super.dispose();
  }

  void _onSnapAnimationTick() {
    final double t = Curves.easeOutCubic.transform(_snapController.value);
    setState(() {
      _imageRect = Rect.lerp(_animStartImageRect, _animEndImageRect, t)!;
      _cropRect = Rect.lerp(_animStartCropRect, _baseCropRect, t)!;
    });
  }

  Future<void> _loadImage() async {
    try {
      final Uint8List bytes = await widget.imageFile.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      codec.dispose();

      if (!mounted) {
        frameInfo.image.dispose();
        return;
      }

      setState(() {
        _decodedImage = frameInfo.image;
      });
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  void _syncLayoutBounds(Size viewportSize) {
    if (_decodedImage == null) return;
    if (_lastViewportSize == viewportSize && _cropRect != null) return;

    final Size imageSize = Size(
      _decodedImage!.width.toDouble(),
      _decodedImage!.height.toDouble(),
    );
    final FittedSizes fitted = applyBoxFit(
      BoxFit.contain,
      imageSize,
      viewportSize,
    );
    final Size dst = fitted.destination;

    final double imgLeft = (viewportSize.width - dst.width) / 2;
    final double imgTop = (viewportSize.height - dst.height) / 2;
    final Rect nextImageRect = Rect.fromLTWH(
      imgLeft,
      imgTop,
      dst.width,
      dst.height,
    );

    _initialImageRect = nextImageRect;
    _imageRect = nextImageRect;
    _lastViewportSize = viewportSize;

    final double minImgSide = dst.width < dst.height ? dst.width : dst.height;
    final double baseSize = minImgSide * 0.72;
    final double cropLeft = imgLeft + (dst.width - baseSize) / 2;
    final double cropTop = imgTop + (dst.height - baseSize) / 2;

    _baseCropRect = Rect.fromLTWH(cropLeft, cropTop, baseSize, baseSize);
    _cropRect = _baseCropRect;
  }

  void _handlePanStart(DragStartDetails details) {
    final Rect? r = _cropRect;
    if (r == null || _isCropping) return;

    if (_snapController.isAnimating) {
      _snapController.stop();
    }

    final Offset p = details.localPosition;
    _CropDragMode detected = _CropDragMode.none;

    if ((p - r.topLeft).distance <= _cornerHitRadius) {
      detected = _CropDragMode.topLeft;
    } else if ((p - r.topRight).distance <= _cornerHitRadius) {
      detected = _CropDragMode.topRight;
    } else if ((p - r.bottomLeft).distance <= _cornerHitRadius) {
      detected = _CropDragMode.bottomLeft;
    } else if ((p - r.bottomRight).distance <= _cornerHitRadius) {
      detected = _CropDragMode.bottomRight;
    } else if ((p.dx - r.left).abs() <= _edgeHitTolerance &&
        p.dy >= r.top &&
        p.dy <= r.bottom) {
      detected = _CropDragMode.left;
    } else if ((p.dx - r.right).abs() <= _edgeHitTolerance &&
        p.dy >= r.top &&
        p.dy <= r.bottom) {
      detected = _CropDragMode.right;
    } else if ((p.dy - r.top).abs() <= _edgeHitTolerance &&
        p.dx >= r.left &&
        p.dx <= r.right) {
      detected = _CropDragMode.top;
    } else if ((p.dy - r.bottom).abs() <= _edgeHitTolerance &&
        p.dx >= r.left &&
        p.dx <= r.right) {
      detected = _CropDragMode.bottom;
    } else if (r.contains(p)) {
      detected = _CropDragMode.move;
    }

    setState(() {
      _dragMode = detected;
      _dragStartCropRect = r;
    });
  }

  void _panImageWhenPushedAtEdge({
    required double rawNewLeft,
    required double rawNewTop,
    required Rect clampedCrop,
    required Rect screenBounds,
  }) {
    double shiftX = 0.0;
    double shiftY = 0.0;

    if (rawNewLeft > screenBounds.right - clampedCrop.width) {
      final double overflowRight =
        rawNewLeft - (screenBounds.right - clampedCrop.width);
      final double availableRight = math.max(
        0.0,
        _imageRect.right - clampedCrop.right,
      );
      shiftX = -math.min(overflowRight, availableRight);
    } else if (rawNewLeft < screenBounds.left) {
      final double overflowLeft = screenBounds.left - rawNewLeft;
      final double availableLeft = math.max(
        0.0,
        clampedCrop.left - _imageRect.left,
      );
      shiftX = math.min(overflowLeft, availableLeft);
    }

    if (rawNewTop > screenBounds.bottom - clampedCrop.height) {
      final double overflowBottom =
        rawNewTop - (screenBounds.bottom - clampedCrop.height);
      final double availableBottom = math.max(
        0.0,
        _imageRect.bottom - clampedCrop.bottom,
      );
      shiftY = -math.min(overflowBottom, availableBottom);
    } else if (rawNewTop < screenBounds.top) {
      final double overflowTop = screenBounds.top - rawNewTop;
      final double availableTop = math.max(
        0.0,
        clampedCrop.top - _imageRect.top,
      );
      shiftY = math.min(overflowTop, availableTop);
    }

    if (shiftX != 0.0 || shiftY != 0.0) {
      _imageRect = _imageRect.shift(Offset(shiftX, shiftY));
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final Rect? r = _cropRect;
    if (r == null || _dragMode == _CropDragMode.none || _isCropping) return;

    final Rect screenBounds = Rect.fromLTRB(
      _screenOuterMargin,
      _screenOuterMargin,
      _lastViewportSize.width - _screenOuterMargin,
      _lastViewportSize.height - _screenOuterMargin,
    );
    final Rect allowedBounds = _imageRect.intersect(screenBounds);

    final Offset p = details.localPosition;
    final double minAllowedSide = allowedBounds.width < allowedBounds.height
      ? allowedBounds.width
      : allowedBounds.height;
    final double effectiveMinSize = minAllowedSide < _minCropSize
      ? minAllowedSide
      : _minCropSize;

    Rect nextRect = r;

    switch (_dragMode) {
      case _CropDragMode.move:
        final double rawLeft = r.left + details.delta.dx;
        final double rawTop = r.top + details.delta.dy;

        final double maxLeft = allowedBounds.right - r.width;
        final double maxTop = allowedBounds.bottom - r.height;
        final double newLeft = rawLeft.clamp(
          allowedBounds.left,
          maxLeft < allowedBounds.left ? allowedBounds.left : maxLeft,
        );
        final double newTop = rawTop.clamp(
          allowedBounds.top,
          maxTop < allowedBounds.top ? allowedBounds.top : maxTop,
        );

        nextRect = Rect.fromLTWH(newLeft, newTop, r.width, r.height);
        _panImageWhenPushedAtEdge(
          rawNewLeft: rawLeft,
          rawNewTop: rawTop,
          clampedCrop: nextRect,
          screenBounds: screenBounds,
        );
        break;

      case _CropDragMode.bottomRight:
        final double maxW = allowedBounds.right - r.left;
        final double maxH = allowedBounds.bottom - r.top;
        final double maxSize = maxW < maxH ? maxW : maxH;
        final double safeMin =
          effectiveMinSize <= maxSize ? effectiveMinSize : maxSize;
        final double dx = p.dx - r.left;
        final double dy = p.dy - r.top;
        final double size = (dx > dy ? dx : dy).clamp(safeMin, maxSize);
        nextRect = Rect.fromLTWH(r.left, r.top, size, size);
        break;

      case _CropDragMode.topLeft:
        final double maxW = r.right - allowedBounds.left;
        final double maxH = r.bottom - allowedBounds.top;
        final double maxSize = maxW < maxH ? maxW : maxH;
        final double safeMin =
          effectiveMinSize <= maxSize ? effectiveMinSize : maxSize;
        final double dx = r.right - p.dx;
        final double dy = r.bottom - p.dy;
        final double size = (dx > dy ? dx : dy).clamp(safeMin, maxSize);
        nextRect = Rect.fromLTWH(r.right - size, r.bottom - size, size, size);
        break;

      case _CropDragMode.topRight:
        final double maxW = allowedBounds.right - r.left;
        final double maxH = r.bottom - allowedBounds.top;
        final double maxSize = maxW < maxH ? maxW : maxH;
        final double safeMin =
          effectiveMinSize <= maxSize ? effectiveMinSize : maxSize;
        final double dx = p.dx - r.left;
        final double dy = r.bottom - p.dy;
        final double size = (dx > dy ? dx : dy).clamp(safeMin, maxSize);
        nextRect = Rect.fromLTWH(r.left, r.bottom - size, size, size);
        break;

      case _CropDragMode.bottomLeft:
        final double maxW = r.right - allowedBounds.left;
        final double maxH = allowedBounds.bottom - r.top;
        final double maxSize = maxW < maxH ? maxW : maxH;
        final double safeMin =
          effectiveMinSize <= maxSize ? effectiveMinSize : maxSize;
        final double dx = r.right - p.dx;
        final double dy = p.dy - r.top;
        final double size = (dx > dy ? dx : dy).clamp(safeMin, maxSize);
        nextRect = Rect.fromLTWH(r.right - size, r.top, size, size);
        break;

      case _CropDragMode.right:
        final double maxW = allowedBounds.right - r.left;
        final double maxSize = maxW < allowedBounds.height
          ? maxW
          : allowedBounds.height;
        final double safeMin =
          effectiveMinSize <= maxSize ? effectiveMinSize : maxSize;
        final double size = (p.dx - r.left).clamp(safeMin, maxSize);
        final double newTop = (r.center.dy - size / 2).clamp(
          allowedBounds.top,
          allowedBounds.bottom - size,
        );
        nextRect = Rect.fromLTWH(r.left, newTop, size, size);
        break;

      case _CropDragMode.left:
        final double maxW = r.right - allowedBounds.left;
        final double maxSize = maxW < allowedBounds.height
          ? maxW
          : allowedBounds.height;
        final double safeMin =
          effectiveMinSize <= maxSize ? effectiveMinSize : maxSize;
        final double size = (r.right - p.dx).clamp(safeMin, maxSize);
        final double newTop = (r.center.dy - size / 2).clamp(
          allowedBounds.top,
          allowedBounds.bottom - size,
        );
        nextRect = Rect.fromLTWH(r.right - size, newTop, size, size);
        break;

      case _CropDragMode.bottom:
        final double maxH = allowedBounds.bottom - r.top;
        final double maxSize = maxH < allowedBounds.width
          ? maxH
          : allowedBounds.width;
        final double safeMin =
          effectiveMinSize <= maxSize ? effectiveMinSize : maxSize;
        final double size = (p.dy - r.top).clamp(safeMin, maxSize);
        final double newLeft = (r.center.dx - size / 2).clamp(
          allowedBounds.left,
          allowedBounds.right - size,
        );
        nextRect = Rect.fromLTWH(newLeft, r.top, size, size);
        break;

      case _CropDragMode.top:
        final double maxH = r.bottom - allowedBounds.top;
        final double maxSize = maxH < allowedBounds.width
          ? maxH
          : allowedBounds.width;
        final double safeMin =
          effectiveMinSize <= maxSize ? effectiveMinSize : maxSize;
        final double size = (r.bottom - p.dy).clamp(safeMin, maxSize);
        final double newLeft = (r.center.dx - size / 2).clamp(
          allowedBounds.left,
          allowedBounds.right - size,
        );
        nextRect = Rect.fromLTWH(newLeft, r.bottom - size, size, size);
        break;

      case _CropDragMode.none:
        break;
    }

    setState(() {
      _cropRect = nextRect;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    final _CropDragMode finishedMode = _dragMode;
    final Rect? currentCrop = _cropRect;

    setState(() {
      _dragMode = _CropDragMode.none;
    });

    if (finishedMode == _CropDragMode.none ||
      finishedMode == _CropDragMode.move) {
        return;
    }

    if (currentCrop == null || _baseCropRect == Rect.zero) return;
    if ((currentCrop.width - _dragStartCropRect.width).abs() <
      _resizeThreshold) {
        return;
    }

    final double minAllowedScale = _initialImageRect.width / _imageRect.width;
    final double maxAllowedScale =
      (_initialImageRect.width * _maxZoomFactor) / _imageRect.width;

    final bool isShrinkingBox = currentCrop.width < _baseCropRect.width;
    final bool isImageCurrentlyZoomedIn =
      _imageRect.width > _initialImageRect.width + 1.0;

    if (!isShrinkingBox && !isImageCurrentlyZoomedIn) {
      return;
    }

    double scale = 1.0;
    if (isShrinkingBox) {
      scale = (_baseCropRect.width / currentCrop.width).clamp(
        1.0,
        maxAllowedScale,
      );
    } else {
      final double maxViewportSide =
        math.min(_lastViewportSize.width, _lastViewportSize.height) -
        (_screenOuterMargin * 2);
      final double outwardSpan = math.max(
        24.0,
        maxViewportSide - _baseCropRect.width,
      );
      final double rawProgress =
        ((currentCrop.width - _baseCropRect.width) / outwardSpan).clamp(
          0.0,
          1.0,
      );
      final double fastOutProgress = (rawProgress * 1.4).clamp(0.0, 1.0);
      scale = ui.lerpDouble(1.0, minAllowedScale, fastOutProgress)!;
    }

    if ((scale - 1.0).abs() < 0.01) return;

    final double nextLeft = _baseCropRect.center.dx +
      (_imageRect.left - currentCrop.center.dx) * scale;
    final double nextTop = _baseCropRect.center.dy +
      (_imageRect.top - currentCrop.center.dy) * scale;
    final double nextWidth = _imageRect.width * scale;
    final double nextHeight = _imageRect.height * scale;

    Rect targetImageRect = Rect.fromLTWH(
      nextLeft,
      nextTop,
      nextWidth,
      nextHeight,
    );

    if (targetImageRect.left > _baseCropRect.left) {
      targetImageRect = targetImageRect.shift(
        Offset(_baseCropRect.left - targetImageRect.left, 0),
      );
    }
    if (targetImageRect.right < _baseCropRect.right) {
      targetImageRect = targetImageRect.shift(
        Offset(_baseCropRect.right - targetImageRect.right, 0),
      );
    }
    if (targetImageRect.top > _baseCropRect.top) {
      targetImageRect = targetImageRect.shift(
        Offset(0, _baseCropRect.top - targetImageRect.top),
      );
    }
    if (targetImageRect.bottom < _baseCropRect.bottom) {
      targetImageRect = targetImageRect.shift(
        Offset(0, _baseCropRect.bottom - targetImageRect.bottom),
      );
    }

    _animStartImageRect = _imageRect;
    _animEndImageRect = targetImageRect;
    _animStartCropRect = currentCrop;

    _snapController.forward(from: 0.0);
  }

  Future<void> _cropAndSaveImage() async {
    if (_isCropping || _decodedImage == null || _cropRect == null) return;
    if (_snapController.isAnimating) {
      _snapController.stop();
      _imageRect = _animEndImageRect;
      _cropRect = _baseCropRect;
    }
    setState(() {
      _isCropping = true;
    });

    try {
      final ui.Image sourceImage = _decodedImage!;
      final Rect crop = _cropRect!;
      final Rect imgRect = _imageRect;
      const int outputDimension = 600;
      final double scaleX = sourceImage.width / imgRect.width;
      final double scaleY = sourceImage.height / imgRect.height;
      final double srcLeft = ((crop.left - imgRect.left) * scaleX).clamp(
        0.0,
        sourceImage.width.toDouble(),
      );
      final double srcTop = ((crop.top - imgRect.top) * scaleY).clamp(
        0.0,
        sourceImage.height.toDouble(),
      );
      final double srcWidth = (crop.width * scaleX).clamp(
        1.0,
        sourceImage.width.toDouble() - srcLeft,
      );
      final double srcHeight = (crop.height * scaleY).clamp(
        1.0,
        sourceImage.height.toDouble() - srcTop,
      );

      final Rect sourceRect = Rect.fromLTWH(
        srcLeft,
        srcTop,
        srcWidth,
        srcHeight,
      );

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      canvas.drawImageRect(
        sourceImage,
        sourceRect,
        Rect.fromLTWH(
          0,
          0,
          outputDimension.toDouble(),
          outputDimension.toDouble(),
        ),
        Paint()..filterQuality = FilterQuality.high,
      );

      final ui.Image croppedImage = await recorder.endRecording().toImage(
        outputDimension,
        outputDimension,
      );

      final ByteData? byteData = await croppedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      croppedImage.dispose();

      if (byteData == null) {
        if (mounted) {
          setState(() => _isCropping = false);
        }
        return;
      }

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName =
        'profile_avatar_${DateTime.now().millisecondsSinceEpoch}.png';
      final File croppedFile = File('${appDir.path}/$fileName');

      await croppedFile.writeAsBytes(
        byteData.buffer.asUint8List(),
        flush: true,
      );

      if (!mounted) return;
      Navigator.of(context).pop(croppedFile.path);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isCropping = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Styles.danger,
          content: Text(
            'Unable to crop photo. Please try again.',
            style: TextStyle(
              color: Styles.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Styles.canvas,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _isCropping
                          ? null
                          : () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Styles.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Styles.borderStrong),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Styles.textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Avatar Studio',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          Text(
                            'Frame your square portrait',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _isCropping
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Styles.primaryLight,
                        ),
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Styles.surfaceHighlight,
                          foregroundColor: Styles.primaryLight,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Styles.primary),
                          ),
                        ),
                        onPressed: _cropAndSaveImage,
                        child: const Text(
                          'APPLY',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: _decodedImage == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Styles.primaryLight,
                      ),
                    )
                  : LayoutBuilder(
                      builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final Size viewportSize = Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          );
                        _syncLayoutBounds(viewportSize);

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: _handlePanStart,
                          onPanUpdate: _handlePanUpdate,
                          onPanEnd: _handlePanEnd,
                          child: Stack(
                            children: [
                              Positioned.fromRect(
                                rect: _imageRect,
                                child: RawImage(
                                  image: _decodedImage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              if (_cropRect != null)
                                PhotoCropOverlay(
                                  cropRect: _cropRect!,
                                  isDragging:
                                    _dragMode != _CropDragMode.none,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Styles.canvas,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const Text(
                'Drag box to position  •  Pull corners or edges to zoom & frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Styles.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}