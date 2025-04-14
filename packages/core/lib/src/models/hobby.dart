import 'package:equatable/equatable.dart';

class Hobby extends Equatable {
  const Hobby({
    required this.id,
    required this.name,
  });

  factory Hobby.fromJson(Map<String, dynamic> json) => Hobby(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  final String id;
  final String name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}

final class Hobbies {
  // Sports & Outdoors
  static const Hobby tennis =
      Hobby(id: '3a1b2c3d-4e5f-6a7b-8c9d-0e1f2a3b4c5d', name: 'Tennis');
  static const Hobby running =
      Hobby(id: '4b2c3d4e-5f6a-7b8c-9d0e-1f2a3b4c5d6e', name: 'Running');
  static const Hobby cycling =
      Hobby(id: '5c3d4e5f-6a7b-8c9d-0e1f-2a3b4c5d6e7f', name: 'Cycling');
  static const Hobby yoga =
      Hobby(id: '6d4e5f6a-7b8c-9d0e-1f2a-3b4c5d6e7f8a', name: 'Yoga');
  static const Hobby hiking =
      Hobby(id: '7e5f6a7b-8c9d-0e1f-2a3b-4c5d6e7f8a9b', name: 'Hiking');
  static const Hobby swimming =
      Hobby(id: '8f6a7b8c-9d0e-1f2a-3b4c-5d6e7f8a9b0c', name: 'Swimming');
  static const Hobby football =
      Hobby(id: '9a7b8c9d-0e1f-2a3b-4c5d-6e7f8a9b0c1d', name: 'Football');
  static const Hobby basketball =
      Hobby(id: '0b8c9d0e-1f2a-3b4c-5d6e-7f8a9b0c1d2e', name: 'Basketball');
  static const Hobby volleyball =
      Hobby(id: '1c9d0e1f-2a3b-4c5d-6e7f-8a9b0c1d2e3f', name: 'Volleyball');
  static const Hobby climbing =
      Hobby(id: '2d0e1f2a-3b4c-5d6e-7f8a-9b0c1d2e3f4a', name: 'Climbing');
  static const Hobby skiing =
      Hobby(id: '3e1f2a3b-4c5d-6e7f-8a9b-0c1d2e3f4a5b', name: 'Skiing');
  static const Hobby snowboarding =
      Hobby(id: '4f2a3b4c-5d6e-7f8a-9b0c-1d2e3f4a5b6c', name: 'Snowboarding');
  static const Hobby skating =
      Hobby(id: '5a3b4c5d-6e7f-8a9b-0c1d-2e3f4a5b6c7d', name: 'Skating');
  static const Hobby fishing =
      Hobby(id: '6b4c5d6e-7f8a-9b0c-1d2e-3f4a5b6c7d8e', name: 'Fishing');
  static const Hobby camping =
      Hobby(id: '7c5d6e7f-8a9b-0c1d-2e3f-4a5b6c7d8e9f', name: 'Camping');

  // Arts & Culture
  static const Hobby music =
      Hobby(id: '8d6e7f8a-9b0c-1d2e-3f4a-5b6c7d8e9f0a', name: 'Music');
  static const Hobby singing =
      Hobby(id: '9e7f8a9b-0c1d-2e3f-4a5b-6c7d8e9f0a1b', name: 'Singing');
  static const Hobby guitar =
      Hobby(id: '0f8a9b0c-1d2e-3f4a-5b6c-7d8e9f0a1b2c', name: 'Guitar');
  static const Hobby piano =
      Hobby(id: '1a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3d', name: 'Piano');
  static const Hobby dancing =
      Hobby(id: '2b0c1d2e-3f4a-5b6c-7d8e-9f0a1b2c3d4e', name: 'Dancing');
  static const Hobby painting =
      Hobby(id: '3c1d2e3f-4a5b-6c7d-8e9f-0a1b2c3d4e5f', name: 'Painting');
  static const Hobby drawing =
      Hobby(id: '4d2e3f4a-5b6c-7d8e-9f0a-1b2c3d4e5f6a', name: 'Drawing');
  static const Hobby photography =
      Hobby(id: '5e3f4a5b-6c7d-8e9f-0a1b-2c3d4e5f6a7b', name: 'Photography');
  static const Hobby writing =
      Hobby(id: '6f4a5b6c-7d8e-9f0a-1b2c-3d4e5f6a7b8c', name: 'Writing');
  static const Hobby theater =
      Hobby(id: '7a5b6c7d-8e9f-0a1b-2c3d-4e5f6a7b8c9d', name: 'Theater');
  static const Hobby museums =
      Hobby(id: '8b6c7d8e-9f0a-1b2c-3d4e-5f6a7b8c9d0e', name: 'Museums');
  static const Hobby concerts =
      Hobby(id: '9c7d8e9f-0a1b-2c3d-4e5f-6a7b8c9d0e1f', name: 'Concerts');

  // Food & Drink
  static const Hobby cooking =
      Hobby(id: '0d8e9f0a-1b2c-3d4e-5f6a-7b8c9d0e1f2a', name: 'Cooking');
  static const Hobby baking =
      Hobby(id: '1e9f0a1b-2c3d-4e5f-6a7b-8c9d0e1f2a3b', name: 'Baking');
  static const Hobby restaurants =
      Hobby(id: '2f0a1b2c-3d4e-5f6a-7b8c-9d0e1f2a3b4c', name: 'Restaurants');
  static const Hobby cafes =
      Hobby(id: '3a1b2c3d-4e5f-6a7b-8c9d-0e1f2a3b4c5d', name: 'Cafes');
  static const Hobby wineTasting =
      Hobby(id: '4b2c3d4e-5f6a-7b8c-9d0e-1f2a3b4c5d6e', name: 'Wine Tasting');
  static const Hobby craftBeer =
      Hobby(id: '5c3d4e5f-6a7b-8c9d-0e1f-2a3b4c5d6e7f', name: 'Craft Beer');

  // Games & Social
  static const Hobby boardGames =
      Hobby(id: '6d4e5f6a-7b8c-9d0e-1f2a-3b4c5d6e7f8a', name: 'Board Games');
  static const Hobby videoGames =
      Hobby(id: '7e5f6a7b-8c9d-0e1f-2a3b-4c5d6e7f8a9b', name: 'Video Games');
  static const Hobby cardGames =
      Hobby(id: '8f6a7b8c-9d0e-1f2a-3b4c-5d6e7f8a9b0c', name: 'Card Games');
  static const Hobby puzzles =
      Hobby(id: '9a7b8c9d-0e1f-2a3b-4c5d-6e7f8a9b0c1d', name: 'Puzzles');
  static const Hobby socializing =
      Hobby(id: '0b8c9d0e-1f2a-3b4c-5d6e-7f8a9b0c1d2e', name: 'Socializing');
  static const Hobby networking =
      Hobby(id: '1c9d0e1f-2a3b-4c5d-6e7f-8a9b0c1d2e3f', name: 'Networking');
  static const Hobby volunteering =
      Hobby(id: '2d0e1f2a-3b4c-5d6e-7f8a-9b0c1d2e3f4a', name: 'Volunteering');

  // Tech & Learning
  static const Hobby programming =
      Hobby(id: '3e1f2a3b-4c5d-6e7f-8a9b-0c1d2e3f4a5b', name: 'Programming');
  static const Hobby technology =
      Hobby(id: '4f2a3b4c-5d6e-7f8a-9b0c-1d2e3f4a5b6c', name: 'Technology');
  static const Hobby languages =
      Hobby(id: '5a3b4c5d-6e7f-8a9b-0c1d-2e3f4a5b6c7d', name: 'Languages');
  static const Hobby reading =
      Hobby(id: '6b4c5d6e-7f8a-9b0c-1d2e-3f4a5b6c7d8e', name: 'Reading');
  static const Hobby workshops =
      Hobby(id: '7c5d6e7f-8a9b-0c1d-2e3f-4a5b6c7d8e9f', name: 'Workshops');
  static const Hobby podcasts =
      Hobby(id: '8d6e7f8a-9b0c-1d2e-3f4a-5b6c7d8e9f0a', name: 'Podcasts');

  // Other
  static const Hobby traveling =
      Hobby(id: '9e7f8a9b-0c1d-2e3f-4a5b-6c7d8e9f0a1b', name: 'Traveling');
  static const Hobby movies =
      Hobby(id: '0f8a9b0c-1d2e-3f4a-5b6c-7d8e9f0a1b2c', name: 'Movies');
  static const Hobby pets =
      Hobby(id: '1a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3d', name: 'Pets');
  static const Hobby gardening =
      Hobby(id: '2b0c1d2e-3f4a-5b6c-7d8e-9f0a1b2c3d4e', name: 'Gardening');
  static const Hobby diyProjects =
      Hobby(id: '3c1d2e3f-4a5b-6c7d-8e9f-0a1b2c3d4e5f', name: 'DIY Projects');

  // List of all hobbies
  static final List<Hobby> all = [
    // Sports & Outdoors
    tennis, running, cycling, yoga, hiking, swimming, football, basketball,
    volleyball, climbing, skiing, snowboarding, skating, fishing, camping,
    // Arts & Culture
    music, singing, guitar, piano, dancing, painting, drawing, photography,
    writing, theater, museums, concerts,
    // Food & Drink
    cooking, baking, restaurants, cafes, wineTasting, craftBeer,
    // Games & Social
    boardGames, videoGames, cardGames, puzzles, socializing, networking,
    volunteering,
    // Tech & Learning
    programming, technology, languages, reading, workshops, podcasts,
    // Other
    traveling, movies, pets, gardening, diyProjects,
  ];

  static Hobby? findById(String id) {
    try {
      return all.firstWhere((hobby) => hobby.id == id);
    } catch (e) {
      return null;
    }
  }
}
