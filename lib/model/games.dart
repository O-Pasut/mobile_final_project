class Games {
  final int id;
  final String slug;
  final String name;
  final int added;

  Games(this.id, this.slug, this.name, this.added);

  Games.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      slug = json['slug'],
      name = json['name'],
      added = json['added'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'slug': slug, 'name': name, 'added': added};
  }
}
