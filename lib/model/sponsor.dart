import 'package:firebase_database/firebase_database.dart';

class SponsorItem {

  SponsorItem(
  this.category,
  this.description,
  this.imageUrl,
  this.priority,
);

  String key;
  String category;
  String description;
  String imageUrl;
  int priority;

  SponsorItem.fromSnapshot(DataSnapshot snapshot):
      key=snapshot.key,
      category=snapshot.value["category"],
      description=snapshot.value["description"],
      imageUrl= snapshot.value["imageUrl"],
      priority=snapshot.value["priority"];

  toJson(){
    return {
      "category": category,
      "description" : description,
      "imageUrl": imageUrl,
      "priority": priority,
    };
  }

}