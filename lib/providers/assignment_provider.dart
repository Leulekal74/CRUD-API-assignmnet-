import 'package:flutter/material.dart';
import '../models/assignment_task.dart';
import '../services/api_service.dart';

class AssignmentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<AssignmentTask> _tasks = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<AssignmentTask> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Read Tasks
  Future<void> loadTasks() async {
    _setLoading(true);
    _clearError();
    try {
      List<AssignmentTask> serverTasks = await _apiService.fetchTasks();
      
      // Injecting a highly unique local task at the very top of your app list
      _tasks = [
        AssignmentTask(
          id: 999,
          studentId: 1,
          taskTitle: "Netcentric CRUD Application Assignment",
          taskDetails: "Implement a clean architecture Flutter app utilizing the HTTP package and Provider state management solutions for submission.",
        ),
        ...serverTasks
      ];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Create Task
  Future<bool> addAssignment(String title, String details) async {
    _setLoading(true);
    try {
      AssignmentTask newTask = await _apiService.createTask(title, details);
      _tasks.insert(0, newTask); 
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update Task
  Future<bool> editAssignment(int id, String title, String details) async {
    _setLoading(true);
    try {
      AssignmentTask updatedTask = await _apiService.updateTask(id, title, details);
      int index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete Task
  Future<bool> removeAssignment(int id) async {
    final existingTaskIndex = _tasks.indexWhere((task) => task.id == id);
    if (existingTaskIndex == -1) return false;
    
    var existingTask = _tasks[existingTaskIndex];
    _tasks.removeAt(existingTaskIndex);
    notifyListeners();

    try {
      await _apiService.deleteTask(id);
      return true;
    } catch (e) {
      _tasks.insert(existingTaskIndex, existingTask);
      _errorMessage = "Failed to drop task from remote registry.";
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
  }
}