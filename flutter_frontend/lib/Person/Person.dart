import 'dart:convert';

class Person {
  static const String defaultImage = 'assets/images/no_photo.png';

  final String name;
  final String job;
  final String description;
  final String? youtube;
  final String? twitter;
  final String? wikipedia;
  final String photo;

  Person(
      this.name,
      this.job,
      this.description,
      {
        this.youtube,
        this.twitter,
        this.wikipedia,
        this.photo = defaultImage
      });

  factory Person.fromJson(Map<String, dynamic> json) {
    String? link = json['link'];
    return Person(
      utf8.decode(latin1.encode(json['name'])),
      json['job'] != null ? utf8.decode(latin1.encode(json['job'])) : 'Безработный' ,
      json['description'] != null ? utf8.decode(latin1.encode(json['description'])) : 'Нет описания',
      twitter: link != null && link.contains('twitter') ? link : null,
      youtube: link != null && link.contains('youtube') ? link : null,
      wikipedia: json['wikipedia'],
      photo: json['photo'] ?? defaultImage,
    );
  }
}