import 'room.dart';

class Venue {
  factory Venue(Map venueData) {
    List<Room> rooms;
    for (Map roomData in venueData["rooms"]) {
      rooms.add(new Room(roomData));
    }

    return Venue._internal(
      id: venueData["id"],
      name: venueData["name"],
      latitude: venueData["latitudeMicrodegrees"],
      longitude: venueData["longitudeMicrodegrees"],
      timezone: venueData["timezone"],
      rooms: rooms,
    );
  }

  Venue._internal({
    this.id, this.name, this.latitude, this.longitude, this.timezone,
    this.rooms});

  final int id;
  final String name;
  final int latitude;
  final int longitude;
  final String timezone;
  final List<Room> rooms;
}