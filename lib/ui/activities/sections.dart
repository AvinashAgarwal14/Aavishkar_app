import 'package:flutter/material.dart';
import '../../model/event.dart';
import './main.dart';

const Color _mariner = Color(0xFF3B5F8F);
const Color _mediumPurple = Color(0xFF8266D4);
const Color _tomato = Color(0xFFF95B57);
const Color _mySin = Color(0xFFF3A646);
const Color _inbetween=Color.fromRGBO(149, 102, 166, 1.0);

class Section {

  Section({
    this.title,
    this.backgroundAsset,
    this.leftColor,
    this.rightColor,
    this.details,
  });

  final String title;
  final String backgroundAsset;
  final Color leftColor;
  final Color rightColor;
  List<EventItem> details;

  @override
  bool operator==(Object other) {
    if (other is! Section)
      return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

List<Section> allSections = <Section>[
  Section(
    title: 'On-site Events',
    leftColor: _mediumPurple,
    rightColor: _mariner,
    backgroundAsset: 'images/activities/onsite.jpeg',
    details: eventsByCategories['On-site']
  ),
  Section(
    title: 'Online Events',
    leftColor: _inbetween,
    rightColor: _mediumPurple,
    backgroundAsset: 'images/activities/online.jpeg',
    details: eventsByCategories['Online']
  ),
  Section(
    title: 'Workshops',
    leftColor: _tomato,
    rightColor: _inbetween,
    backgroundAsset: 'images/activities/workshops.jpeg',
    details: eventsByCategories['Workshops']
  ),
  Section(
    title: 'Special Attractions',
    leftColor: _mySin,
    rightColor: _tomato,
    backgroundAsset: 'images/activities/special attraction.jpeg',
    details: eventsByCategories['Games']
  ),
  Section(
    title: 'Ignitia',
    leftColor: Colors.white,
    rightColor: _tomato,
    backgroundAsset: 'images/activities/ignitia.jpeg',
      details: eventsByCategories['Ignitia']
  ),
];