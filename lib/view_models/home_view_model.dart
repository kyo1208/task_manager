import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firebase_service.dart'; // Import FirebaseService

class HomeViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService(); // Initialize FirebaseService
  List<Task> _tasks = []; // List to store all tasks
  List<Task> _filteredTasks = []; // List to store filtered tasks
  String _currentQuery = ''; // Current search query

  List<Task> get tasks => _filteredTasks.isNotEmpty ? _filteredTasks : _tasks; // Getter for tasks, prioritizing filteredTasks if not empty

  HomeViewModel() {
    _loadTasks(); // Load tasks when ViewModel is initialized
  }

  // Method to load tasks from Firestore
  void _loadTasks() async {
    _tasks = await _firebaseService.getTasks(); // Fetch tasks from Firestore
    if (_currentQuery.isNotEmpty) {
      searchTasks(_currentQuery); // Apply current search query
    }
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to add a new task
  void addTask(Task task) async {
    await _firebaseService.addTask(task); // Add task to Firestore
    _loadTasks(); // Reload tasks
  }

  // Method to delete a task by ID
  void deleteTask(String id) async {
    await _firebaseService.deleteTask(id); // Delete task from Firestore
    _loadTasks(); // Reload tasks
  }

  // Method to toggle task completion status
  void toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted; // Toggle task completion status
    await _firebaseService.updateTask(task); // Update task in Firestore
    _loadTasks(); // Reload tasks
  }

  // Method to search tasks based on query
  void searchTasks(String query) async {
    _currentQuery = query; // Update current query
    if (query.isEmpty) {
      _filteredTasks.clear(); // Clear filtered tasks if query is empty
    } else {
      _filteredTasks = _tasks.where((task) => task.title.toLowerCase().contains(query.toLowerCase())).toList(); // Filter tasks by title
    }
    notifyListeners(); // Notify listeners to update UI
  }
}
