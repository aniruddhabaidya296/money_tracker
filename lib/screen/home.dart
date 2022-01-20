import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:money_tracker/blocs/user_bloc/user_bloc.dart';
import 'package:money_tracker/components/card_user.dart';
import 'package:money_tracker/constants/colors.dart';
import 'package:money_tracker/constants/custom_log.dart';
import 'package:money_tracker/helper/user_helper.dart';
import 'package:money_tracker/models/user.dart';
import 'package:money_tracker/screen/home_page.dart';
import '../constants/size_config.dart';
import 'initial_page.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserHelper userHelper = UserHelper();
  List<User> allUsers = [];
  TextEditingController personNameController = TextEditingController();
  UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = BlocProvider.of<UserBloc>(context);
    getUserList();
  }

  getUserList() async {
    var users = await userHelper.getAllUsers().then((list) {
      if (list.isNotEmpty) {
        for (var i in list) {
          i.print();
        }
        setState(() {
          allUsers = list;
        });
      }
    });
  }

  _dialogEnterPersonName() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: AlertDialog(
            title: Text('Enter Person Name'),
            content: TextField(
              controller: personNameController,
              decoration: textFieldDecoration("Name"),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(bottom: SizeConfig.blockHeight * 2),
            actions: [
              MaterialButton(
                onPressed: () {
                  var _user = User(
                    id: DateTime.now().millisecondsSinceEpoch,
                    personName: personNameController.text,
                    netTotal: 0,
                  );
                  userHelper.saveUser(user: _user);
                  userBloc.add(FetchAllUser());
                  setState(() {
                    personNameController.text = '';
                  });
                  getUserList();
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.blockWidth * 2,
                  ),
                ),
                color: Colors.amberAccent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration textFieldDecoration(String text) {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockWidth * 4,
            vertical: SizeConfig.blockHeight * 1),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 1),
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 1),
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockWidth * 1),
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        labelStyle: TextStyle(color: Colors.black),
        labelText: "$text",
        hintStyle: TextStyle(color: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SizeConfig().init(context);
    // getUserList();
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.amber,
              height: height * 0.15,
              padding: EdgeInsets.only(
                left: SizeConfig.blockWidth * 4,
                right: SizeConfig.blockWidth * 4,
                top: width * 0.18,
                bottom: width * 0.05,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Money Tracker",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.074 //30
                    ),
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 2),
                // color: Colors.blue[50],
                width: width,
                // height: height * 0.47,
                child: allUsers.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Add people with whom you transacted.",
                        ),
                      )
                    : BlocBuilder(
                        bloc: userBloc,
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return CircularProgressIndicator();
                          } else if (state is FetchUserFailed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Something went wrong",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                              ),
                            );
                            // return Container();
                          } else if (state is FetchUserSuccess) {
                            allUsers = state.users;
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: allUsers.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockWidth * 2,
                                vertical: SizeConfig.blockHeight * 3,
                              ),
                              itemBuilder: (context, index) {
                                User user = allUsers[index];
                                User tempUser = allUsers[index];
                                return Dismissible(
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    setState(() {
                                      allUsers.removeAt(index);
                                    });
                                    userHelper.deleteUser(user);
                                    final snackBar = SnackBar(
                                      content: Text(
                                        "User Deleted",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15))),
                                      action: SnackBarAction(
                                        label: "Undo",
                                        textColor: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            allUsers.insert(index, tempUser);
                                          });
                                          userHelper.saveUser(user: tempUser);
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    // _scafoldKey.currentState.showSnackBar(snackBar);
                                  },
                                  key: ValueKey(user.id),
                                  background: Container(
                                    padding: EdgeInsets.only(
                                        right: 10, top: width * 0.04),
                                    alignment: Alignment.topRight,
                                    // color: Colors.white,
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: width * 0.07,
                                    ),
                                  ),
                                  child: UserCard(
                                    user: user,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InitialPage(
                                            userId:
                                                allUsers[index].id.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    lastItem: allUsers[index] == allUsers.last
                                        ? true
                                        : false,
                                  ),
                                );
                              },
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: COLORS.deepBlue,
        ),
        backgroundColor: Colors.amber,
        onPressed: () {
          _dialogEnterPersonName();
        },
      ),
    );
  }
}
