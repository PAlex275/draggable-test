import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/table_bloc.dart';

class DraggablePerson extends StatelessWidget {
  final String person;
  final String tableId;

  DraggablePerson({required this.person, required this.tableId});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: person,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.amberAccent,
          child: Text(person,
              style: const TextStyle(fontSize: 18, color: Colors.black)),
        ),
      ),
      childWhenDragging: Container(),
      child: ListTile(
        title: Text(person),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            BlocProvider.of<TableBloc>(context)
                .add(RemovePersonFromTableEvent(tableId, person));
          },
        ),
      ),
    );
  }
}
