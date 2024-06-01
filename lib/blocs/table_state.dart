part of 'table_bloc.dart';

abstract class TableState extends Equatable {
  const TableState();

  @override
  List<Object> get props => [];
}

class TableInitial extends TableState {}

class TableLoaded extends TableState {
  final List<TableModel> tables;

  const TableLoaded({required this.tables});

  @override
  List<Object> get props => [tables];
}
