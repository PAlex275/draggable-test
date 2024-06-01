part of 'table_bloc.dart';

abstract class TableEvent extends Equatable {
  const TableEvent();

  @override
  List<Object> get props => [];
}

class AddTableEvent extends TableEvent {}

class RemoveTableEvent extends TableEvent {
  final String index;

  const RemoveTableEvent(this.index);

  @override
  List<Object> get props => [index];
}

class AddPersonToTableEvent extends TableEvent {
  final String tableId;
  final String person;

  const AddPersonToTableEvent(this.tableId, this.person);

  @override
  List<Object> get props => [tableId, person];
}

class RemovePersonFromTableEvent extends TableEvent {
  final String tableId;
  final String person;

  const RemovePersonFromTableEvent(this.tableId, this.person);

  @override
  List<Object> get props => [tableId, person];
}

class AddPersonToFirstAvailableTableEvent extends TableEvent {
  final String person;

  const AddPersonToFirstAvailableTableEvent(this.person);

  @override
  List<Object> get props => [person];
}
