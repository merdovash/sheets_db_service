import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sheets_items/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Person.dart';

class PersonCard extends StatelessWidget {
  static const List<double> defaultRanges = [300, 1080];
  final Person person;

  const PersonCard(this.person, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var width = mq.size.width; // 392
    var height  = mq.size.height; // 759

    var textPadding = convertRange(defaultRanges, [16, 40], width);


    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              margin: EdgeInsets.all(convertRange(defaultRanges, [4, 25], width)),
              child: ClipOval(
                  child: _image(convertRange(defaultRanges, [70, 200], width))
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: textPadding, bottom: textPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    person.name,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: convertRange(defaultRanges, [18, 25], width),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                      person.job,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: convertRange(defaultRanges, [16, 21], width)
                      )
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40, top: 5),
                    child: Text(
                        person.description,
                        style: const TextStyle(
                            //overflow: TextOverflow.fade,
                            color: Colors.black87,
                            fontSize: 14
                        )
                    ),
                  ),
                ),
                //const Spacer(),
                Flexible(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (person.twitter != null) IconButton(
                          onPressed: () async => _launchUrl(person.twitter),
                          color: Colors.lightBlue,
                          icon: FaIcon(FontAwesomeIcons.twitter),
                          splashRadius: 20,
                        ),
                        if (person.youtube != null) IconButton(
                          onPressed: () async => _launchUrl(person.youtube),
                          color: Colors.red,
                          icon: FaIcon(FontAwesomeIcons.youtube),
                          splashRadius: 20,
                        ),
                        if (person.wikipedia != null) IconButton(
                          onPressed: () async => _launchUrl(person.wikipedia),
                          icon: FaIcon(FontAwesomeIcons.wikipediaW),
                          splashRadius: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget defaultImage(double photoSize) {
    return Image.asset(
        Person.defaultImage,
        width: photoSize
    );
  }

  Widget _image(double photoSize) {
    if (person.photo.startsWith('http')) {
      return Image.network(
        person.photo,
        width: photoSize,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => defaultImage(photoSize)
      );
    }

    return Image.asset(
      person.photo,
      width: photoSize,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => defaultImage(photoSize)
    );
  }

  _launchUrl(String? url) async {
    if (url == null) return;
    if (!await launch(url)) throw 'Could not launch ${url}';
  }
}