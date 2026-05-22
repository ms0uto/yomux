import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nihongo_reader/core/routing/app_routes.dart';
import 'package:nihongo_reader/features/ocr/ocr_mode.dart';
import 'package:nihongo_reader/features/ocr/ocr_service.dart';

enum _OcrUiPhase { idle, loading, ready, error }

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key, required this.mode});

  final String mode;

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  final _textController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _ocrService = OcrService();
  late final OcrMode _ocrMode;

  _OcrUiPhase _phase = _OcrUiPhase.idle;
  String? _errorMessage;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _ocrMode = OcrMode.fromRoute(widget.mode);
    WidgetsBinding.instance.addPostFrameCallback((_) => _pickAndRecognize());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Camera: compress JPEG capture. Gallery: full-quality original (no re-encode).
  Future<XFile?> _pickImage() {
    return switch (_ocrMode) {
      OcrMode.camera => _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 92,
          preferredCameraDevice: CameraDevice.rear,
        ),
      OcrMode.gallery => _imagePicker.pickImage(
          source: ImageSource.gallery,
          requestFullMetadata: true,
        ),
    };
  }

  Future<void> _pickAndRecognize() async {
    setState(() {
      _phase = _OcrUiPhase.loading;
      _errorMessage = null;
    });

    try {
      final picked = await _pickImage();

      if (!mounted) return;

      if (picked == null) {
        setState(() {
          _phase = _OcrUiPhase.idle;
          _imageFile = null;
        });
        return;
      }

      setState(() => _imageFile = picked);

      final text = await _ocrService.recognizeFromFile(
        picked.path,
        source: _ocrMode.routeValue,
      );

      if (!mounted) return;

      _textController.text = text;
      setState(() => _phase = _OcrUiPhase.ready);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _phase = _OcrUiPhase.error;
        _errorMessage = _friendlyError(error);
        _imageFile = null;
      });
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('camera') || message.contains('Camera')) {
      return 'Could not open the camera. Check permissions and try again.';
    }
    if (message.contains('photo') || message.contains('gallery')) {
      return 'Could not open the photo library. Check permissions and try again.';
    }
    return 'Something went wrong while reading the image. Please try again.';
  }

  void _continueToReader() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.push(AppRoutes.reader, extra: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(_ocrMode.screenTitle)),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return switch (_phase) {
      _OcrUiPhase.loading => const _OcrLoadingView(),
      _OcrUiPhase.error => _OcrErrorView(
          message: _errorMessage ?? 'Recognition failed.',
          onRetry: _pickAndRecognize,
        ),
      _OcrUiPhase.idle => _OcrEmptyView(
          mode: _ocrMode,
          onRetry: _pickAndRecognize,
        ),
      _OcrUiPhase.ready => _OcrReviewView(
          imageFile: _imageFile,
          controller: _textController,
          onTextChanged: () => setState(() {}),
          onConfirm: _continueToReader,
          onChooseAnother: _pickAndRecognize,
        ),
    };
  }
}

class _OcrLoadingView extends StatelessWidget {
  const _OcrLoadingView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Reading Japanese text…',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This runs on your device only.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _OcrEmptyView extends StatelessWidget {
  const _OcrEmptyView({
    required this.mode,
    required this.onRetry,
  });

  final OcrMode mode;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final actionLabel = mode == OcrMode.camera ? 'Take photo' : 'Choose image';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 64,
            color: colorScheme.outline,
          ),
          const SizedBox(height: 20),
          Text(
            'No image selected',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            mode == OcrMode.camera
                ? 'Take a photo of Japanese text to extract and review it here.'
                : 'Choose an image with Japanese text to extract and review it here.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: onRetry,
            icon: Icon(
              mode == OcrMode.camera
                  ? Icons.camera_alt_outlined
                  : Icons.photo_library_outlined,
            ),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _OcrErrorView extends StatelessWidget {
  const _OcrErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 56, color: colorScheme.error),
          const SizedBox(height: 20),
          Text(
            'Could not read text',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

/// Shows the full source image (no crop) so OCR can be checked against the photo.
class _OcrReviewImagePreview extends StatefulWidget {
  const _OcrReviewImagePreview({
    required this.path,
    required this.maxHeight,
  });

  final String path;
  final double maxHeight;

  @override
  State<_OcrReviewImagePreview> createState() => _OcrReviewImagePreviewState();
}

class _OcrReviewImagePreviewState extends State<_OcrReviewImagePreview> {
  double? _aspectRatio;

  @override
  void initState() {
    super.initState();
    _loadAspectRatio();
  }

  Future<void> _loadAspectRatio() async {
    try {
      final bytes = await File(widget.path).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final ratio = frame.image.width / frame.image.height;
      frame.image.dispose();
      if (!mounted) return;
      setState(() => _aspectRatio = ratio);
    } catch (_) {
      if (!mounted) return;
      setState(() => _aspectRatio = 3 / 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = widget.maxHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (_aspectRatio == null) {
          return SizedBox(
            height: maxHeight * 0.35,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        var width = constraints.maxWidth;
        var height = width / _aspectRatio!;
        if (height > maxHeight) {
          height = maxHeight;
          width = height * _aspectRatio!;
        }

        return Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: width,
              height: height,
              child: InteractiveViewer(
                panAxis: PanAxis.free,
                minScale: 0.75,
                maxScale: 4,
                child: Image.file(
                  File(widget.path),
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

int _ocrTextFieldMinLines(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return 1;
  final lineCount = '\n'.allMatches(text).length + 1;
  return lineCount.clamp(1, 20);
}

class _OcrReviewView extends StatelessWidget {
  const _OcrReviewView({
    required this.imageFile,
    required this.controller,
    required this.onTextChanged,
    required this.onConfirm,
    required this.onChooseAnother,
  });

  final XFile? imageFile;
  final TextEditingController controller;
  final VoidCallback onTextChanged;
  final VoidCallback onConfirm;
  final VoidCallback onChooseAnother;

  void _dismissKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canContinue = controller.text.trim().isNotEmpty;
    final textMinLines = _ocrTextFieldMinLines(controller.text);
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final imageMaxHeight = keyboardOpen
        ? 100.0
        : MediaQuery.sizeOf(context).height * 0.42;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (imageFile != null) ...[
          GestureDetector(
            onTap: () => _dismissKeyboard(context),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _OcrReviewImagePreview(
                path: imageFile!.path,
                maxHeight: imageMaxHeight,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => _dismissKeyboard(context),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Fix any OCR mistakes before you continue.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  onChanged: (_) => onTextChanged(),
                  maxLines: null,
                  minLines: textMinLines,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  scrollPadding: const EdgeInsets.only(bottom: 120),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize:
                        (theme.textTheme.bodyLarge?.fontSize ?? 16) + 2,
                    height: 1.55,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Recognized Japanese text will appear here…',
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: onChooseAnother,
          child: const Text('Choose another image'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: FilledButton(
            onPressed: canContinue ? onConfirm : null,
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }
}
