import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../application/providers/online_reg_providers.dart';
import '../../domain/models/online_reg_model.dart';

class OnlineRegForm extends ConsumerStatefulWidget {
  final OnlineRegModel? initialData;

  const OnlineRegForm({super.key, this.initialData});

  @override
  ConsumerState<OnlineRegForm> createState() => _OnlineRegFormState();
}

class _OnlineRegFormState extends ConsumerState<OnlineRegForm> {
  final _formKey = GlobalKey<FormState>();
  final _programNameController = TextEditingController();
  final _dataByHandController = TextEditingController();
  final _registeredCountController = TextEditingController();
  final _confirmedCountController = TextEditingController();
  final _messagedController = TextEditingController();
  final _remindedController = TextEditingController();
  final _notSureController = TextEditingController();
  final _notComingController = TextEditingController();
  final _remarksController = TextEditingController();

  DateTime? _programDate;
  DateTime? _regStartDate;
  DateTime? _regEndDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _programNameController.text = data.programName;
      _dataByHandController.text = data.dataByHand;
      _registeredCountController.text = data.registeredCount.toString();
      _confirmedCountController.text = data.confirmedCount.toString();
      _messagedController.text = data.messaged.toString();
      _remindedController.text = data.reminded.toString();
      _notSureController.text = data.notSure.toString();
      _notComingController.text = data.notComing.toString();
      _remarksController.text = data.remarks;

      _programDate = data.programDate;
      _regStartDate = data.regStartDate;
      _regEndDate = data.regEndDate;
    } else {
      // Set default values for new entries
      _registeredCountController.text = '0';
      _confirmedCountController.text = '0';
      _messagedController.text = '0';
      _remindedController.text = '0';
      _notSureController.text = '0';
      _notComingController.text = '0';
      _dataByHandController.text = 'No';
    }
  }

  @override
  void dispose() {
    _programNameController.dispose();
    _dataByHandController.dispose();
    _registeredCountController.dispose();
    _confirmedCountController.dispose();
    _messagedController.dispose();
    _remindedController.dispose();
    _notSureController.dispose();
    _notComingController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, void Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_programDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select all required dates')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final onlineRegModel = OnlineRegModel(
        id: widget.initialData?.id ?? const Uuid().v4(),
        programName: _programNameController.text,
        programDate: _programDate!,
        regStartDate: _regStartDate!,
        regEndDate: _regEndDate!,
        dataByHand: _dataByHandController.text,
        registeredCount: int.parse(_registeredCountController.text),
        confirmedCount: int.parse(_confirmedCountController.text),
        messaged: int.parse(_messagedController.text),
        reminded: int.parse(_remindedController.text),
        notSure: int.parse(_notSureController.text),
        notComing: int.parse(_notComingController.text),
        remarks: _remarksController.text,
      );

      if (widget.initialData == null) {
        // Create new registration
        ref.read(createOnlineRegProvider(onlineRegModel));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration created successfully! 🎉')));
        }
      } else {
        // Update existing registration
        ref.read(updateOnlineRegProvider(onlineRegModel));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration updated successfully! ✅')));
        }
      }
      // refetch data
      ref.invalidate(getOnlineRegProvider);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()} ❌')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData == null ? 'Create Registration' : 'Edit Registration'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _isLoading ? null : _saveForm, tooltip: 'Save')],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Program Name
                        TextFormField(
                          controller: _programNameController,
                          decoration: const InputDecoration(labelText: 'Program Name *', prefixIcon: Icon(Icons.event), border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter program name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Program Date
                        InkWell(
                          onTap: () => _selectDate(context, _programDate, (date) => setState(() => _programDate = date)),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Program Date *',
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                            child: Text(_programDate == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(_programDate!)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Registration Start Date
                        InkWell(
                          onTap: () => _selectDate(context, _regStartDate, (date) => setState(() => _regStartDate = date)),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Registration Start Date ',
                              prefixIcon: Icon(Icons.date_range),
                              border: OutlineInputBorder(),
                            ),
                            child: Text(_regStartDate == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(_regStartDate!)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Registration End Date
                        InkWell(
                          onTap: () => _selectDate(context, _regEndDate, (date) => setState(() => _regEndDate = date)),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Registration End Date ',
                              prefixIcon: Icon(Icons.event_busy),
                              border: OutlineInputBorder(),
                            ),
                            child: Text(_regEndDate == null ? 'Select Date' : DateFormat('dd/MM/yyyy').format(_regEndDate!)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Data By Hand
                        TextFormField(
                          controller: _dataByHandController,
                          decoration: const InputDecoration(
                            labelText: 'Data By Hand',
                            prefixIcon: Icon(Icons.edit),
                            border: OutlineInputBorder(),
                            hintText: 'Yes/No',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Counters Section
                        const Text('Registration Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),

                        // Two columns for counters
                        Row(
                          children: [
                            // Left column
                            Expanded(
                              child: Column(
                                children: [
                                  // Registered Count
                                  TextFormField(
                                    controller: _registeredCountController,
                                    decoration: const InputDecoration(
                                      labelText: 'Registered',
                                      prefixIcon: Icon(Icons.people),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Enter a number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Confirmed Count
                                  TextFormField(
                                    controller: _confirmedCountController,
                                    decoration: const InputDecoration(
                                      labelText: 'Confirmed',
                                      prefixIcon: Icon(Icons.check_circle),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Enter a number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Messaged
                                  TextFormField(
                                    controller: _messagedController,
                                    decoration: const InputDecoration(
                                      labelText: 'Messaged',
                                      prefixIcon: Icon(Icons.message),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Enter a number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Right column
                            Expanded(
                              child: Column(
                                children: [
                                  // Reminded
                                  TextFormField(
                                    controller: _remindedController,
                                    decoration: const InputDecoration(
                                      labelText: 'Reminded',
                                      prefixIcon: Icon(Icons.notifications),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Enter a number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Not Sure
                                  TextFormField(
                                    controller: _notSureController,
                                    decoration: const InputDecoration(
                                      labelText: 'Not Sure',
                                      prefixIcon: Icon(Icons.help),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Enter a number';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Not Coming
                                  TextFormField(
                                    controller: _notComingController,
                                    decoration: const InputDecoration(
                                      labelText: 'Not Coming',
                                      prefixIcon: Icon(Icons.cancel),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required';
                                      }
                                      if (int.tryParse(value) == null) {
                                        return 'Enter a number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Remarks
                        TextFormField(
                          controller: _remarksController,
                          decoration: const InputDecoration(labelText: 'Remarks', prefixIcon: Icon(Icons.note), border: OutlineInputBorder()),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _saveForm,
                            icon: const Icon(Icons.save),
                            label: Text(
                              widget.initialData == null ? 'Create Registration' : 'Update Registration',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
