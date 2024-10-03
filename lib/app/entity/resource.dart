class Resource {
  final String name;
  final String slug;
  final String description;
  final String image;
  final String type;
  int currentCount;

  Resource({
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.type,
    this.currentCount = 0,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      image: json['image'],
      type: json['type'],
      currentCount: json['currentCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'description': description,
      'image': image,
      'type': type,
      'currentCount': currentCount,
    };
  }
}
