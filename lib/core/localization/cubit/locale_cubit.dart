import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar'));

  void setLocale(Locale locale) => emit(locale);

  void toggleLocale() {
    emit(state.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
  }
}
