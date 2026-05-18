import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/assignment_task.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET: Read Tasks
  Future<List<AssignmentTask>> fetchTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => AssignmentTask.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load tasks from server repository');
    }
  }

  // POST: Create Task
  Future<AssignmentTask> createTask(String title, String details) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': title, 'body': details, 'userId': 1}),
    );

    if (response.statusCode == 201) {
      return AssignmentTask.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register new task on remote server');
    }
  }

  // PUT: Update Task
  Future<AssignmentTask> updateTask(int id, String title, String details) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'id': id, 'title': title, 'body': details, 'userId': 1}),
    );

    if (response.statusCode == 200) {
      return AssignmentTask.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save task updates on remote server');
    }
  }

  // DELETE: Delete Task
  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task from server database');
    }
  }
}