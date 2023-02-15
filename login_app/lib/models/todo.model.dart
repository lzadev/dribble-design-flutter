class TodoModel {
  int? id;
  String title;
  String task;
  int done;
  TodoModel({this.id, required this.title, required this.task, this.done = 0});

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
      id: json["id"],
      title: json["title"],
      task: json["task"],
      done: json["done"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "title": title, "task": task, "done": done};
}
