import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../models/table_model.dart';

part 'table_event.dart';
part 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(const TableLoaded(tables: [])) {
    on<AddTableEvent>(_onAddTable);
    on<RemoveTableEvent>(_onRemoveTable);
    on<AddPersonToTableEvent>(_onAddPersonToTable);
    on<RemovePersonFromTableEvent>(_onRemovePersonFromTable);
    on<AddPersonToFirstAvailableTableEvent>(_onAddPersonToFirstAvailableTable);
  }

  void _onAddTable(AddTableEvent event, Emitter<TableState> emit) {
    if (state is TableLoaded) {
      final tables = List<TableModel>.from((state as TableLoaded).tables);
      tables.add(TableModel(id: const Uuid().v4()));
      emit(TableLoaded(tables: tables));
    }
  }

  void _onRemoveTable(RemoveTableEvent event, Emitter<TableState> emit) {
    if (state is TableLoaded) {
      final tables = List<TableModel>.from((state as TableLoaded).tables);
      tables.removeWhere((element) => element.id == event.index);
      emit(TableLoaded(tables: tables));
    }
  }

  void _onAddPersonToTable(
      AddPersonToTableEvent event, Emitter<TableState> emit) {
    if (state is TableLoaded) {
      final tables = (state as TableLoaded).tables.map((table) {
        if (table.id == event.tableId) {
          return TableModel(
              id: table.id,
              persons: List.from(table.persons)..add(event.person));
        }
        return table;
      }).toList();
      emit(TableLoaded(tables: tables));
    }
  }

  void _onRemovePersonFromTable(
      RemovePersonFromTableEvent event, Emitter<TableState> emit) {
    if (state is TableLoaded) {
      final tables = (state as TableLoaded).tables.map((table) {
        if (table.id == event.tableId) {
          return TableModel(
              id: table.id,
              persons: List.from(table.persons)..remove(event.person));
        }
        return table;
      }).toList();
      emit(TableLoaded(tables: tables));
    }
  }

  void _onAddPersonToFirstAvailableTable(
      AddPersonToFirstAvailableTableEvent event, Emitter<TableState> emit) {
    if (state is TableLoaded) {
      final tables = (state as TableLoaded).tables;
      if (tables.isNotEmpty) {
        final updatedTables = tables.map((table) {
          if (table.id == tables.first.id) {
            return TableModel(
                id: table.id,
                persons: List.from(table.persons)..add(event.person));
          }
          return table;
        }).toList();
        emit(TableLoaded(tables: updatedTables));
      }
    }
  }
}
