import 'dart:convert';

class Image {
  int id;
  int appointmentId;
  String imagePath;
  double zoomLevel;
  String eyeDescription;
  String dateTime;

  Image({
    this.id,
    this.appointmentId,
    this.imagePath,
    this.zoomLevel,
    this.eyeDescription,
    this.dateTime,
  });

  factory Image.fromMap(Map<String, dynamic> json) => Image(
    id: json["id"],
    appointmentId: json["appointment_id"],
    imagePath: json["image_path"],
    zoomLevel: json["zoom_level"],
    eyeDescription: json["eye_descripton"],
    dateTime: json["date_time"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "appointment_id": appointmentId,
    "image_path": imagePath,
    "zoom_level": zoomLevel,
    "eye_descripton": eyeDescription,
    "date_time": dateTime,
  };

  Image imageFromJson(String str) {
    final jsonData = json.decode(str);
    return Image.fromMap(jsonData);
  }

  String imageToJson(Image image) {
    final map = image.toMap();
    return json.encode(map);
  }

  @override
  String toString() => "Image: id: $id - appointmentId: $appointmentId - imagePath: $imagePath - zoomLevel: $zoomLevel - eyeDescription: $eyeDescription - dateTime: $dateTime";
}
