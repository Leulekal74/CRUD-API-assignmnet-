import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/assignment_task.dart';
import '../providers/assignment_provider.dart';

class AssignmentFormScreen extends StatefulWidget {
  final AssignmentTask? task; 

  const AssignmentFormScreen({super.key, this.task});

  @override
  State<AssignmentFormScreen> createState() => _AssignmentFormScreenState();
}

class _AssignmentFormScreenState extends State<AssignmentFormScreen> {
  final _formValidationKey = GlobalKey<FormState>();
  late TextEditingController _titleInputController;
  late TextEditingController _detailsInputController;

  @override
  void initState() {
    super.initState();
    _titleInputController = TextEditingController(text: widget.task?.taskTitle ?? '');
    _detailsInputController = TextEditingController(text: widget.task?.taskDetails ?? '');
  }

  @override
  void dispose() {
    _titleInputController.dispose();
    _detailsInputController.dispose();
    super.dispose();
  }

  void _processFormSubmission() async {
    if (!_formValidationKey.currentState!.validate()) return;

    final provider = Provider.of<AssignmentProvider>(context, listen: false);
    bool isUpdateMode = widget.task != null;
    bool success;

    if (isUpdateMode) {
      success = await provider.editAssignment(
        widget.task!.id!,
        _titleInputController.text,
        _detailsInputController.text,
      );
    } else {
      success = await provider.addAssignment(
        _titleInputController.text,
        _detailsInputController.text,
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isUpdateMode ? 'Assignment data updated' : 'New coursework metric logged')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Encountered: ${provider.errorMessage}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdateMode = widget.task != null;
    final provider = Provider.of<AssignmentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdateMode ? 'Modify Project Parameters' : 'Register New Metric'),
      ),
      body: provider.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formValidationKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleInputController,
                      decoration: const InputDecoration(
                        labelText: 'Course or Project Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.book_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Please specify task title mapping' : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _detailsInputController,
                      decoration: const InputDecoration(
                        labelText: 'Task Details / Milestone Requirements',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      maxLines: 4,
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Milestone description entries are required' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _processFormSubmission,
                        icon: const Icon(Icons.save_as_outlined),
                        label: Text(isUpdateMode ? 'Apply Updates' : 'Commit to Board'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}