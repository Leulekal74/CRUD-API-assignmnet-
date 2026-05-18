import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assignment_provider.dart';
import 'assignment_form_screen.dart';

class AssignmentDashboardScreen extends StatelessWidget {
  const AssignmentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AssignmentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 AAiT Assignment Monitor'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: provider.isLoading && provider.tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage.isNotEmpty && provider.tasks.isEmpty
              ? Center(child: Text('Error Trace: ${provider.errorMessage}'))
              : RefreshIndicator(
                  onRefresh: () => provider.loadTasks(),
                  child: ListView.builder(
                    itemCount: provider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = provider.tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        elevation: 1.5,
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.assignment_outlined),
                          ),
                          title: Text(
                            task.taskTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            task.taskDetails,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.rate_review, color: Colors.blueGrey), // Custom edit style
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssignmentFormScreen(task: task),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.archive_outlined, color: Colors.redAccent), // Custom archive style
                                onPressed: () async {
                                  final success = await provider.removeAssignment(task.id ?? 0);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success 
                                          ? 'Task archived/removed from board' 
                                          : 'Failed to complete task removal'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssignmentFormScreen()),
          );
        },
        icon: const Icon(Icons.playlist_add),
        label: const Text('Add Task'),
      ),
    );
  }
}