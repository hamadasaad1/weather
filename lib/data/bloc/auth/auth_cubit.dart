import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:weather/data/local/data_source/local_cache_helper.dart';
import 'package:weather/data/remote/model/user_model.dart';
import 'package:weather/data/repositories/firestore_user.dart';
import 'package:weather/presentation/resources/strings_manager.dart';

import '../../singleton.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signInWithEmailPassword(
    String email,
    String password,
  ) async {
    emit(AuthLoginLoadingState());
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        print(value.user!.email);
        await getCurrentUserData(value.user!.uid);
        CacheHelper.setDataToSharedPref(key: AppStrings.email, value: email);
        CacheHelper.setDataToSharedPref(
            key: AppStrings.password, value: password);
        emit(AuthLoginSuccessState());
      });
    } catch (error) {
      debugPrint("Error" + error.toString());
      emit(AuthLoginErrorState(error.toString()));
    }
  }

  void createAccountWithEmailPassword(
    String email,
    String password,
    String name,
    String location,
  ) async {
    emit(AuthSignUpLoadingState());
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        UserModel userModel = UserModel(
            userId: user.user?.uid,
            email: user.user?.email,
            name: name,
            location: location);
        await FireStoreUser().addUserToFireStore(userModel);
        await getCurrentUserData(user.user!.uid);
        CacheHelper.setDataToSharedPref(key: AppStrings.email, value: email);
        CacheHelper.setDataToSharedPref(
            key: AppStrings.password, value: password);
        emit(AuthSignUpSuccessState());
      });
    } catch (error) {
      debugPrint("Error" + error.toString());
      emit(AuthSignUpErrorState(error.toString()));
    }
  }

  void saveUserFireStore(UserCredential user) async {
    UserModel userModel = UserModel(
      userId: user.user?.uid,
      email: user.user?.email,
      name: user.user?.displayName ?? "",
    );
    await FireStoreUser().addUserToFireStore(userModel).then((value) {
      setUser(userModel);
    });
  }

  setUser(UserModel model) async {
    Singleton().userModel = model;
    emit(AuthUpdateUserDataState(model));
  }

  Future<void> getCurrentUserData(String uid) async {
    await FireStoreUser().getCurrentUser(uid).then((value) {
      debugPrint(value.id);
      debugPrint(Singleton().userModel?.name);
      setUser(UserModel.fromJson(value.data() as Map));
    });
  }

  void updateEmail(email) async {
    emit(AuthUpdateProfileLoadingState());

    var firebaseUser = await _firebaseAuth.currentUser;

    firebaseUser!.updateEmail(email).then(
      (value) async {
        await FireStoreUser()
            .updateUserSingleValue(firebaseUser.uid, 'email', email);
        emit(AuthUpdateProfileSuccessState());
      },
    ).catchError((onError) {
      emit(AuthUpdateProfileErrorState(onError.toString()));
    });
  }

  void changePassword(String currentPassword, String newPassword) async {
    emit(AuthUpdateProfileLoadingState());
    var user = await FirebaseAuth.instance.currentUser!;

    final cred = await EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);
    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) async {
        emit(AuthUpdateProfileSuccessState());
      }).catchError((error) {
        debugPrint(error);
        emit(AuthUpdateProfileErrorState(error.toString()));
      });
    }).catchError((err) {
      debugPrint(err);
      emit(AuthUpdateProfileErrorState(err.toString()));
    });
  }

  void updateUser(UserModel userModel) async {
    emit(AuthUpdateProfileLoadingState());
    var user = await FirebaseAuth.instance.currentUser!;
    FireStoreUser().updateUser(user.uid, userModel).then((value) async {
      await getCurrentUserData(user.uid);
      emit(AuthUpdateProfileSuccessState());
    }).catchError((onError) {
      emit(AuthUpdateProfileErrorState(onError.toString()));
    });
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
