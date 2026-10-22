
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState {
  idle,
  loading,
  success,
  empty,
  error,
}

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() =>
      _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  String _category = 'Driver concern';
  bool _simulateFailure = false;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _uiState = ReportUiState.loading;
    });

    try {
      // Simulated asynchronous operation; no real API is connected.
      await Future<void>.delayed(
        const Duration(seconds: 5),
      );

      if (_simulateFailure) {
        throw Exception('Simulated submission failure');
      }

      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.success;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.error;
      });
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear();

    setState(() {
      _category = 'Driver concern';
      _simulateFailure = false;
      _uiState = ReportUiState.idle;
    });
  }

  Widget _buildStateMessage() {
    switch (_uiState) {
      case ReportUiState.idle:
        return const SizedBox.shrink();

      case ReportUiState.loading:
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Submitting report... Please wait.'),
              ],
            ),
          ),
        );

      case ReportUiState.success:
        return Card(
          color: Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 32,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Report submitted successfully!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'This is a simulated confirmation. '
                  'No report was saved to a database.',
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Create Another Report',
                  onPressed: _resetForm,
                ),
              ],
            ),
          ),
        );

      case ReportUiState.empty:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.inbox_outlined, size: 40),
                const SizedBox(height: 8),
                const Text(
                  'No reports available yet.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This is an empty-state demonstration.',
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Create a Report',
                  onPressed: () {
                    setState(() {
                      _uiState = ReportUiState.idle;
                    });
                  },
                ),
              ],
            ),
          ),
        );

      case ReportUiState.error:
        return Card(
          color: Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 32,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unable to submit the report.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'A simulated error occurred. '
                  'You can retry the submission.',
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Retry Submission',
                  onPressed: _submitReport,
                ),
              ],
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _uiState == ReportUiState.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TrikeFind - Report Form'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Report a Concern',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tell us about a tricycle driver or passenger concern.',
              ),
              const SizedBox(height: 24),

              if (_uiState == ReportUiState.idle ||
                  _uiState == ReportUiState.loading ||
                  _uiState == ReportUiState.error)
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        hint: 'Report title',
                        controller: _titleController,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter a report title.';
                          }
                          if (value.trim().length < 3) {
                            return 'Enter at least 3 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          labelText: 'Report category',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Driver concern',
                            child: Text('Driver concern'),
                          ),
                          DropdownMenuItem(
                            value: 'Passenger concern',
                            child: Text('Passenger concern'),
                          ),
                          DropdownMenuItem(
                            value: 'Location issue',
                            child: Text('Location issue'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: isLoading
                            ? null
                            : (value) {
                                if (value != null) {
                                  setState(() {
                                    _category = value;
                                  });
                                }
                              },
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        hint: 'Location or terminal',
                        controller: _locationController,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter a location.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        hint: 'Describe the concern',
                        controller: _descriptionController,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please describe the concern.';
                          }
                          if (value.trim().length < 10) {
                            return 'Enter at least 10 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Simulate a submission error',
                        ),
                        subtitle: const Text(
                          'For Activity 9 testing only.',
                        ),
                        value: _simulateFailure,
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _simulateFailure =
                                      value ?? false;
                                });
                              },
                      ),
                      const SizedBox(height: 12),

                      AppButton(
                        text: isLoading
                            ? 'Submitting...'
                            : 'Submit Report',
                        onPressed: isLoading
                            ? () {}
                            : _submitReport,
                      ),

                      if (isLoading) ...[
                        const SizedBox(height: 12),
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 20),
              _buildStateMessage(),

              if (!isLoading &&
                  _uiState != ReportUiState.empty)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _uiState = ReportUiState.empty;
                    });
                  },
                  icon: const Icon(Icons.inbox_outlined),
                  label: const Text('View Reports (Empty Demo)'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
