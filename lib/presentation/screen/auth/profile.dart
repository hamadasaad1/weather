import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:weather/data/local/data_source/local_cache_helper.dart';
import 'package:weather/data/remote/model/user_model.dart';
import 'package:weather/presentation/resources/font_manager.dart';
import 'package:weather/presentation/resources/manager_values.dart';
import 'package:weather/presentation/resources/styles_manager.dart';
import 'package:weather/presentation/screen/splash_screen.dart';

import '../../../data/bloc/auth/auth_cubit.dart';
import '../../../data/singleton.dart';
import '../../component/component.dart';
import '../../resources/color_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late AuthCubit authCubit;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var nameController = TextEditingController();
  bool isDense = false;
  String? latLng;
  final _formKey = GlobalKey<FormState>();
  UserModel? userModel;
  @override
  void initState() {
    getProfileData(user: Singleton().userModel);
    super.initState();
  }

  void getProfileData({UserModel? user}) {
    if (user != null) {
      userModel = user;
      emailController.text = userModel?.email ?? '';
      nameController.text = userModel?.name ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) {
        authCubit = AuthCubit();
        return authCubit;
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/register.png'),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: AppSize.s0,
          ),
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 80),
              child: const Text(
                "Profile",
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthUpdateUserDataState) {
                  userModel = state.userModel;
                  getProfileData(user: userModel);
                }
                if (state is AuthUpdateProfileLoadingState) {
                  showSmartDialog();
                }
                if (state is AuthUpdateProfileErrorState) {
                  SmartDialog.dismiss();
                  showSnackBar(context, state.message);
                }
                if (state is AuthUpdateProfileSuccessState) {
                  SmartDialog.dismiss();
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        right: 35,
                        left: 35,
                        top: MediaQuery.of(context).size.height * 0.27),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        textField(
                          'Name',
                          () {},
                          controller: nameController,
                        ),
                        const SizedBox(height: AppSize.s20),
                        InkWell(
                          onTap: () {
                            changeEmail(context);
                          },
                          child: textField(
                            'Email',
                            () {},
                            isClicable: false,
                            isEmailKeyboard: true,
                            controller: emailController,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: button(() {
                              changePassword(context);
                            }, 'Change Password')),
                            const SizedBox(
                              width: AppSize.s12,
                            ),
                            Expanded(
                                child: button(() {
                              changeLocation(context);
                            }, 'Change Location')),
                          ],
                        ),
                        const SizedBox(height: AppSize.s20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Update',
                                style: getSemiBoldStyle(
                                  color: Colors.white,
                                  fontSize: FontSize.s22,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: ColorManager.primary,
                                child: state is AuthSignUpLoadingState
                                    ? CircularProgressIndicator(
                                        color: ColorManager.white,
                                      )
                                    : IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            userModel!.name =
                                                nameController.text;
                                            if (userModel != null) {
                                              authCubit.updateUser(userModel!);
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.arrow_forward),
                                      ),
                              ),
                            ]),
                        const SizedBox(height: AppSize.s20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Out',
                                style: getSemiBoldStyle(
                                  color: Colors.white,
                                  fontSize: FontSize.s22,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: ColorManager.error,
                                child: state is AuthSignUpLoadingState
                                    ? CircularProgressIndicator(
                                        color: ColorManager.white,
                                      )
                                    : IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          CacheHelper.clear();
                                          Singleton().userModel = null;
                                          authCubit.signOut();
                                          changeNavigatorReplacement(
                                              context, const SplashScreen());
                                        },
                                        icon: const Icon(Icons.arrow_forward),
                                      ),
                              ),
                            ]),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }

  void _getUserLocation() async {
    var position = await Singleton().getGeoLocationPosition();

    if (position != null) {
      latLng = '${position.latitude},${position.longitude}';
      if (userModel != null) {
        userModel?.location = latLng;
        authCubit.updateUser(userModel!);
      }
    }
  }

  Future<void> changeLocation(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Location', textAlign: TextAlign.center),
          actions: <Widget>[
            Center(
              child: Text(
                'Do you want to update to the current location',
                style: getMediumStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: button(() {
                    Navigator.pop(context);
                  }, 'Cancel', buttonColor: ColorManager.grey),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: button(() {
                    Navigator.of(context).pop();
                    _getUserLocation();
                  }, 'Change', buttonColor: ColorManager.lightPrimary),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> changeEmail(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Email', textAlign: TextAlign.center),
          actions: <Widget>[
            textField(
              'Email',
              () {},
              isEmailKeyboard: true,
              controller: emailController,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: button(() {
                    Navigator.pop(context);
                  }, 'Cancel', buttonColor: ColorManager.grey),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: button(() {
                    Navigator.of(context).pop();
                    authCubit.updateEmail(emailController.text);
                  }, 'Change', buttonColor: ColorManager.lightPrimary),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> changePassword(
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password', textAlign: TextAlign.center),
          actions: <Widget>[
            textField(
              'current password',
              () {},
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(
              height: 10,
            ),
            textField(
              'new password',
              () {},
              isPassword: true,
              controller: newPasswordController,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: button(() {
                    Navigator.pop(context);
                  }, 'Cancel', buttonColor: ColorManager.grey),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: button(() {
                    Navigator.of(context).pop();
                    authCubit.changePassword(
                        passwordController.text, newPasswordController.text);
                  }, 'Change', buttonColor: ColorManager.lightPrimary),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
