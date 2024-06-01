import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:draggable_widget_test/blocs/table_bloc.dart';
import 'package:draggable_widget_test/widgets/draggable_table.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scale = 1.0;
  Offset _previousOffset = Offset.zero;
  Offset _offset = Offset.zero;
  final double _scaleDamping = 0.02; // Smaller value for gentler scaling
  final double _panDamping = 0.5; // Smaller value for gentler panning

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedding Table Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              BlocProvider.of<TableBloc>(context).add(AddTableEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<TableBloc, TableState>(
        builder: (context, state) {
          if (state is TableInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TableLoaded) {
            return GestureDetector(
              onScaleStart: (details) {
                _previousOffset = details.focalPoint;
              },
              onScaleUpdate: (details) {
                setState(() {
                  double deltaScale = details.scale;
                  _scale += (deltaScale - 1) * _scaleDamping;
                  _scale = _scale.clamp(0.5, 4.0); // Limit scale factor

                  Offset deltaOffset =
                      (details.focalPoint - _previousOffset) * _panDamping;
                  _previousOffset = details.focalPoint;
                  _offset +=
                      deltaOffset / _scale; // Adjust panning by scale factor
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 1.4,
                height: MediaQuery.of(context).size.height * 1.4,
                color: Colors.grey[200],
                child: ClipRect(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(_offset.dx, _offset.dy)
                      ..scale(_scale),
                    child: Stack(
                      children: [
                        for (int i = 0; i < state.tables.length; i++)
                          DraggableTable(
                            initialPosition: Offset(
                              100.0 * i,
                              100.0 * i,
                            ),
                            tableModel: state.tables[i],
                            onDragCompleted: (position) {},
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPersonDialog(context);
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddPersonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController personController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Person'),
          content: TextField(
            controller: personController,
            decoration: const InputDecoration(hintText: 'Enter person name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (personController.text.isNotEmpty) {
                  BlocProvider.of<TableBloc>(context).add(
                    AddPersonToFirstAvailableTableEvent(
                      personController.text,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
