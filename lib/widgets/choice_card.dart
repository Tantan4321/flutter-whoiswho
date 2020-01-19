import 'package:flutter/material.dart';
import 'package:flutter_whoiswho/ui/AppColors.dart';


String toTitleCase(String givenString) {
  givenString = givenString.substring(0, givenString.lastIndexOf('.zip'));
  List<String> arr = givenString.split("_");
  String ret = "";
  for (int i = 0; i < arr.length; i++) {
    ret += arr[i].substring(0,1).toUpperCase();
    ret += arr[i].substring(1) + " ";
  }
  return ret.trim();
}

class DataChoiceCard extends StatelessWidget {
  const DataChoiceCard({
    @required VoidCallback this.onPressed,
    this.name,
    Key key,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String name;
  final Color cardColor = AppColors.copper;


  Widget _buildCardContent() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: toTitleCase(name),
              child: Material(
                color: Colors.transparent,
                child: Text(
                  toTitleCase(name),
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
