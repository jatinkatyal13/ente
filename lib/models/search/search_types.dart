import "package:flutter/material.dart";

enum ResultType {
  collection,
  file,
  location,
  month,
  year,
  fileType,
  fileExtension,
  fileCaption,
  event
}

enum SectionType {
  face,
  // Grouping based on ML or manual tagging
  content,
  // includes year, month , day, event ResultType
  moment,
  location,
  // People section shows the files shared by other persons
  people,
  album,
  fileTypesAndExtension,
  fileCaption,
}

extension SectionTypeExtensions on SectionType {
  // passing context for internalization in the future
  String sectionTitle(BuildContext context) {
    switch (this) {
      case SectionType.face:
        return "Faces";
      case SectionType.content:
        return "Contents";
      case SectionType.moment:
        return "Moments";
      case SectionType.location:
        return "Location";
      case SectionType.people:
        return "People";
      case SectionType.album:
        return "Albums";
      case SectionType.fileTypesAndExtension:
        return "File types and names";
      case SectionType.fileCaption:
        return "Photo descriptions";
    }
  }

  // get int id to each section for ordering them
  int get orderID {
    switch (this) {
      case SectionType.face:
        return 0;
      case SectionType.content:
        return 1;
      case SectionType.moment:
        return 2;
      case SectionType.location:
        return 3;
      case SectionType.people:
        return 4;
      case SectionType.album:
        return 5;
      case SectionType.fileTypesAndExtension:
        return 6;
      case SectionType.fileCaption:
        return 7;
    }
  }

  String getEmptyStateText(BuildContext context) {
    switch (this) {
      case SectionType.face:
        return "Find all photos of a person";
      case SectionType.content:
        return "Contents";
      case SectionType.moment:
        return "Search by a date, month or year";
      case SectionType.location:
        return "Group photos that are taken within some radius of a photo";
      case SectionType.people:
        return "Invite people, and you'll see all photos shared by them here";
      case SectionType.album:
        return "Albums";
      case SectionType.fileTypesAndExtension:
        return "File types and names";
      case SectionType.fileCaption:
        return "Add descriptions like \"#trip\" in photo info to quickly find "
            "them here";
    }
  }

  // isCTAVisible is used to show/hide the CTA button in the empty state
  // Disable the CTA for face, content, moment, fileTypesAndExtension, fileCaption
  bool get isCTAVisible {
    switch (this) {
      case SectionType.face:
        return true;
      case SectionType.content:
        return false;
      case SectionType.moment:
        return false;
      case SectionType.location:
        return true;
      case SectionType.people:
        return true;
      case SectionType.album:
        return true;
      case SectionType.fileTypesAndExtension:
        return false;
      case SectionType.fileCaption:
        return true;
    }
  }

  String getCTAText(BuildContext context) {
    switch (this) {
      case SectionType.face:
        return "Setup";
      case SectionType.content:
        return "Add tags";
      case SectionType.moment:
        return "Add new";
      case SectionType.location:
        return "Add new";
      case SectionType.people:
        return "Invite";
      case SectionType.album:
        return "Add new";
      case SectionType.fileTypesAndExtension:
        return "";
      case SectionType.fileCaption:
        return "Add new";
    }
  }

  IconData? getCTAIcon() {
    switch (this) {
      case SectionType.face:
        return Icons.adaptive.arrow_forward_outlined;
      case SectionType.content:
        return null;
      case SectionType.moment:
        return null;
      case SectionType.location:
        return Icons.add_location_alt;
      case SectionType.people:
        return Icons.adaptive.share;
      case SectionType.album:
        return Icons.add;
      case SectionType.fileTypesAndExtension:
        return null;
      case SectionType.fileCaption:
        return null;
    }
  }
}
