import 'package:flutter/material.dart';
import 'package:money_tracker/constants/size_config.dart';

import '../helper/transaction_helper.dart';
import '../helper/user_helper.dart';
import 'custom_dialog.dart';

class UserCard extends StatelessWidget {
  final User user;
  final bool lastItem;
  final VoidCallback onPressed;

  const UserCard({Key key, this.user, this.lastItem = false, this.onPressed})
      : super(key: key);

  // _dialogDelete(BuildContext context, double width) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             "Delete transaction?",
  //             textAlign: TextAlign.start,
  //             style: TextStyle(
  //                 fontWeight: FontWeight.bold, color: Colors.lightBlue[700]),
  //           ),
  //           backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(width * 0.050),
  //           ),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Container(
  //                   child: Text(
  //                     "${transaction.description}",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: width * 0.045,
  //                       color: transaction.type.toString() == "g"
  //                           ? Colors.green[600]
  //                           : Colors.red[600],
  //                     ),
  //                   ),
  //                 ),
  //                 Text(
  //                   "Rs ${transaction.value}",
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: transaction.type.toString() == "g"
  //                           ? Colors.green[600]
  //                           : Colors.red[600]),
  //                 ),
  //                 SizedBox(
  //                   height: 40,
  //                 ),
  //                 Divider(
  //                   color: Colors.grey[400],
  //                   height: 2,
  //                 ),
  //                 SizedBox(
  //                   height: 40,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: <Widget>[
  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Container(
  //                         padding: EdgeInsets.only(
  //                             top: width * 0.02,
  //                             bottom: width * 0.02,
  //                             left: width * 0.03,
  //                             right: width * 0.03),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(15),
  //                           // color: Colors.red[700],
  //                           border: Border.all(
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "No",
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: width * 0.04),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         TransactionHelper transactionHelper =
  //                             TransactionHelper();
  //                         transactionHelper.deleteTransaction(transaction);
  //                         Navigator.pop(context);
  //                       },
  //                       child: Container(
  //                         padding: EdgeInsets.only(
  //                             top: width * 0.02,
  //                             bottom: width * 0.02,
  //                             left: width * 0.03,
  //                             right: width * 0.03),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(15),
  //                           color: Colors.red[700],
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             "Yes",
  //                             style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: width * 0.04),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  // _dialogEdit(BuildContext context, double width, Transaction movimentacao) {
  //   print(
  //     movimentacao.toString(),
  //   );
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return CustomDialog(
  //           transaction: movimentacao,
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            onPressed();
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
                        user.personName,
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
        lastItem == true
            ? Container(
                height: height * 0.08 / 2.5,
              )
            : Container()
      ],
    );
  }
}
