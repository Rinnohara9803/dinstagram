import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String username;
  final String caption;
  const ExpandableTextWidget({
    super.key,
    required this.username,
    required this.caption,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final caption = widget.caption;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          children: [
            TextSpan(
              text: widget.username, // Count value
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: caption, // Word "likes"
            ),
          ],
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        final isTextOverflowed = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: _isExpanded
                  ? textSpan
                  : TextSpan(
                      children: [
                        TextSpan(
                          text: widget.username, // Count value
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: caption.substring(
                            0,
                            isTextOverflowed
                                ? textPainter
                                    .getPositionForOffset(
                                      Offset(
                                        constraints.maxWidth,
                                        constraints.maxHeight,
                                      ),
                                    )
                                    .offset
                                : caption.length,
                          ),
                        ),
                      ],
                    ),
            ),
            if (isTextOverflowed)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Show less' : 'Show more',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
