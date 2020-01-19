import 'package:flutter/material.dart';


String capitalizeFirstChar(String text) {
  if (text == null || text.length <= 1) {
    return text.toUpperCase();
  }
  String ret = text[0].toUpperCase();
  if (text.contains('.zip')) {
    ret += text.substring(1, text.lastIndexOf('.zip'));
  } else {
    ret += text.substring(1);
  }
  return ret;
}

class DataChoiceCard extends StatelessWidget {
  const DataChoiceCard({
    @required VoidCallback this.onPressed,
    this.name,
    Key key,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String name;
  final Color cardColor = Colors.cyan;


  Widget _buildCardContent() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: capitalizeFirstChar(name),
              child: Material(
                color: Colors.transparent,
                child: Text(
                  capitalizeFirstChar(name),
                  style: TextStyle(
                    fontSize: 26,
                    height: 0.7,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: cardColor,
              child: InkWell(
                onTap: () => onPressed(),
                splashColor: Colors.white10,
                highlightColor: Colors.white10,
                child: Stack(
                  children: [
                    _buildCardContent(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
