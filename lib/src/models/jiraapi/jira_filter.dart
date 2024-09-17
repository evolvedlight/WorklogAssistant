class JiraFilter {
  final String name;
  final int id;

  JiraFilter({required this.name, required this.id});

  factory JiraFilter.fromJson(Map<String, dynamic> json) {
    return JiraFilter(
      name: json['name'],
      id: int.parse(json['id']),
    );
  }
}
