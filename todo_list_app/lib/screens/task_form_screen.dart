import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  var _editedTask = Task(
      id: '',
      title: '',
      description: '',
      dueDate: DateTime.now(),
      category: 'Pessoal');
  var _isLoading = false;

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedTask.id.isEmpty) {
      await Provider.of<TaskProvider>(context, listen: false)
          .addTask(_editedTask);
    } else {
      await Provider.of<TaskProvider>(context, listen: false)
          .updateTask(_editedTask);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Tarefa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editedTask = Task(
                          id: _editedTask.id,
                          title: value!,
                          description: _editedTask.description,
                          dueDate: _editedTask.dueDate,
                          category: _editedTask.category,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira um título.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editedTask = Task(
                          id: _editedTask.id,
                          title: _editedTask.title,
                          description: value!,
                          dueDate: _editedTask.dueDate,
                          category: _editedTask.category,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira uma descrição.';
                        }
                        return null;
                      },
                    ),
                    // Outros campos de formulário...
                  ],
                ),
              ),
            ),
    );
  }
}
