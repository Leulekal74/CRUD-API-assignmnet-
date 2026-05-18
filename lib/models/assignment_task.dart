class AssignmentTask {
  final int? id;
  final int studentId;
  final String taskTitle;
  final String taskDetails;

  AssignmentTask({
    this.id,
    required this.studentId,
    required this.taskTitle,
    required this.taskDetails,
  });

  // Maps JSON from JSONPlaceholder to our custom assignment model
  factory AssignmentTask.fromJson(Map<String, dynamic> json) {
    return AssignmentTask(
      id: json['id'],
      studentId: json['userId'] ?? 1,
      taskTitle: json['title'] ?? 'Untitled Task',
      taskDetails: json['body'] ?? 'No details provided.',
    );
  }

  // Converts our assignment model back to JSON format for the API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': studentId,
      'title': taskTitle,
      'body': taskDetails,
    };
  }
}