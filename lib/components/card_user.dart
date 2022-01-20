import 'package:flutter/material.dart';
import 'package:money_tracker/constants/custom_log.dart';
import 'package:money_tracker/constants/size_config.dart';
import 'package:money_tracker/models/user.dart';

import '../helper/transaction_helper.dart';
import '../helper/user_helper.dart';
import 'custom_dialog.dart';

class UserCard extends StatefulWidget {
  final User user;
  final bool lastItem;
  final VoidCallback onPressed;

  const UserCard({Key key, this.user, this.lastItem = false, this.onPressed})
      : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

// class _UserCardState extends State<UserCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
class _UserCardState extends State<UserCard> {
  TransactionHelper transactionHelper = TransactionHelper();
  double userNetTotal;
  List<Transaction> transactionList = [];

  @override
  void initState() {
    super.initState();
    userNetTotal = 0;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // calculateUserNetTotal();
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            widget.onPressed();
          },
          onLongPress: () {
            // _dialogDelete(context, width);
          },
          child: Container(
            width: width,
            height: height * 0.07,
            margin: EdgeInsets.only(bottom: SizeConfig.blockHeight * 2),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 10,
                      offset: Offset(2, 3),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Container(
                    width: SizeConfig.blockWidth * 80,
                    child: ListTile(
                      title: Text(
                        widget.user.personName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          // color: user.type == "g"
                          //     ? Colors.green[700]
                          //     : Colors.red[700],
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.044,
                        ),
                      ),
                      trailing: userNetTotal == null
                          ? null
                          : Text(
                              userNetTotal.toString(),
                            ),
                    ),
                  ),
                )),

            // Text(
            //   user.type == "g"
            //       ? "+ ${user.value}"
            //       : " ${user.value}",
            //   style: TextStyle(
            //     color: user.type == "g"
            //         ? Colors.green[700]
            //         : Colors.red[700],
            //     fontWeight: FontWeight.bold,
            //     fontSize: width * 0.044,
            //   ),
            // ),
          ),
        ),
        widget.lastItem == true
            ? Container(
                height: height * 0.08 / 2.5,
              )
            : Container()
      ],
    );
  }
}
