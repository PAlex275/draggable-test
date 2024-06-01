import 'dart:math';
import 'package:draggable_widget_test/blocs/table_bloc.dart';
import 'package:draggable_widget_test/models/table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DraggableTable extends StatefulWidget {
  final TableModel tableModel;
  final Offset initialPosition;
  final Function(Offset) onDragCompleted;

  DraggableTable({
    required this.tableModel,
    required this.initialPosition,
    required this.onDragCompleted,
  });

  @override
  _DraggableTableState createState() => _DraggableTableState();
}

class _DraggableTableState extends State<DraggableTable> {
  Offset position = Offset.zero;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: position,
      child: GestureDetector(
        onTap: () {
          _showNamesDialog(context, widget.tableModel.persons);
        },
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
          widget.onDragCompleted(position);
        },
        child: buildTable(),
      ),
    );
  }

  Widget buildTable() {
    return Container(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            child: Text(
              'Table\n${widget.tableModel.id.substring(0, 4)}',
              textAlign: TextAlign.center,
            ),
          ),
          for (int i = 0; i < widget.tableModel.persons.length; i++)
            _buildPersonAvatar(widget.tableModel.persons[i], i,
                widget.tableModel.persons.length),
        ],
      ),
    );
  }

  Widget _buildPersonAvatar(String person, int index, int total) {
    final initials = person.split(' ').map((word) => word[0]).take(2).join();
    final angle = (2 * pi * index) / total;
    const radius = 60.0;

    return Positioned(
      left: 75 + radius * cos(angle) - 15,
      top: 75 + radius * sin(angle) - 15,
      child: CircleAvatar(
        radius: 15,
        child: Text(
          initials.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  void _showNamesDialog(BuildContext context, List<String> names) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Persons at Table'),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: names.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(names[index]),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<TableBloc>(context)
                            .add(RemoveTableEvent(widget.tableModel.id));
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('Delete Table'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
