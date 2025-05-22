import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flavorith/features/user/data/repositories/user_repository.dart';

// Events
abstract class UserEvent {}

// States
abstract class UserState {}

class UserInitial extends UserState {}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({
    required this.userRepository,
  }) : super(UserInitial());
} 