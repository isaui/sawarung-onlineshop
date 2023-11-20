import 'package:flutter/material.dart';

class ExpandableDescription extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableDescription({Key? key, required this.text, this.maxLines = 3}) : super(key: key);

  @override
  _ExpandableDescriptionState createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 12),

      decoration: BoxDecoration(
          //color: Colors.indigoAccent.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigoAccent.shade200)
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textPainter = TextPainter(
            text: TextSpan(text: widget.text),
            maxLines: isExpanded ? null : widget.maxLines,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(maxWidth: constraints.maxWidth);

          final bool isTextOverflowing = textPainter.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: isExpanded ? textPainter.size.height : null,
                child: Text(
                  widget.text,
                  maxLines: isExpanded ? null : widget.maxLines,
                  overflow: TextOverflow.fade,
                ),
              ),
              if (isTextOverflowing && !isExpanded) // Menambahkan kondisi untuk menampilkan tombol "Show All"
                Column(
                  children: [
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = true; // Mengubah status menjadi true untuk menampilkan seluruh teks
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Show All',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              if (isExpanded) // Menambahkan kondisi untuk menampilkan tombol "Show Less"
                Column(
                  children: [
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = false; // Mengubah status menjadi false untuk menyembunyikan teks yang berlebihan
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Show Less',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
