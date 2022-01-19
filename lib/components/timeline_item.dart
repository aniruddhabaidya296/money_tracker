import 'package:flutter/material.dart';
import 'package:money_tracker/constants/size_config.dart';
import '../helper/transaction_helper.dart';

class TimeLineItem extends StatelessWidget {
  final Transaction transaction;
  final bool isLast;
  final Color colorItem;

  const TimeLineItem({Key key, this.transaction, this.isLast, this.colorItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width * 0.03,
                height: height * 0.015,
                decoration: BoxDecoration(
                    color: colorItem, //Colors.red[900],
                    borderRadius: BorderRadius.circular(10)),
              ),
              Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: Text(
                      transaction.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.05,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.05, top: width * 0.02),
                    child: Text(
                      transaction.date,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.034,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.05),
            child: Text(
              transaction.type == "g"
                  ? "+ ${transaction.value}"
                  : " ${transaction.value}",
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colorItem,
                fontSize: width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
