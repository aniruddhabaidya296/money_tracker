import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_tracker/constants/custom_log.dart';
import 'package:money_tracker/helper/user_helper.dart';
import 'package:money_tracker/models/user.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserEventInitial()) {
    on<FetchAllUser>((event, emit) async {
      await mapFetchAllUserToState(event, emit);
    });
  }

  Future<void> mapFetchAllUserToState(
      FetchAllUser event, Emitter<UserState> emit) async {
    try {
      customLog("Fetching all users...");
      UserHelper userHelper = UserHelper();
      List<User> users = [];
      users = await userHelper.getAllUsers();
      customLog(users);
      // users.map((e) {
      //   customLog("user is $e");
      // });
      emit(FetchUserSuccess(users: users));
    } catch (e) {
      customLog(e.toString());
      emit(FetchUserFailed());
    }
  }
}
