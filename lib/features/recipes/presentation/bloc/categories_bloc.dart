import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_prueba/core/usecases/usecase.dart';
import 'package:recipes_prueba/features/recipes/domain/usecases/get_categories.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<LoadCategoriesEvent, CategoriesState> {
  final GetCategories getCategories;

  CategoriesBloc({required this.getCategories}) : super(CategoriesInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<CategoriesState> emit) async {
    emit(CategoriesLoading());
    try {
      final categories = await getCategories(NoParams());
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
