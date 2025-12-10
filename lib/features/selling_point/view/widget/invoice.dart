import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pos_app/core/utils/extensions.dart';




class InvoicePrintWidget extends StatefulWidget {
  const InvoicePrintWidget({super.key, });



  @override
  State<InvoicePrintWidget> createState() => _InvoicePrintWidgetState();
}

class _InvoicePrintWidgetState extends State<InvoicePrintWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Center(
            child: TextWidgetPrinter(
              text: "شركة تسلم",
              textAlign: TextAlign.center,
            ),
          ),


          Center(
            child: TextWidgetPrinter(
              text: "Teslm Company",
              textAlign: TextAlign.center,
            ),
          ),

          Center(
            child: TextWidgetPrinter(
              text: 'jhsgdkjsagdkj',
              textAlign: TextAlign.center,
            ),
          ),

          Center(
            child: TextWidgetPrinter(
              text: '#${123 ?? ""}',
              textAlign: TextAlign.center,
            ),
          ),



          Divider(color: Colors.black),



          Center(
            child: TextWidgetPrinter(
              text: ' عناصر',
              textAlign: TextAlign.center,
            ),
          ),

          Divider(color: Colors.black),

          ...List.generate(
           3,
                (index1) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            textAlign: TextAlign.start,
                            "'jhjgkj'",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ).expand,
                      Text(
                        textAlign: TextAlign.start,
                        "${2313210 /*+(OrderController().getExtraItemPrice(order?.items?[index1].selectedOptionGroups))*/}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                           5,
                                (index2) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                3,
                                    (index3) => Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        textAlign: TextAlign.start,
                                        "+ ${'jjgdiugad'}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ).expand,
                                      Text(
                                        textAlign: TextAlign.start,
                                        "${121 /*+(OrderController().getExtraItemPrice(order?.items?[index1].selectedOptionGroups))*/} ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).expand,

                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.black),



          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgetPrinter(
                    text: 'المجموع',
                    textAlign: TextAlign.start,
                  ),

                  TextWidgetPrinter(
                    text: 'subtotal',
                    textAlign: TextAlign.start,
                  ),
                ],
              ).expand,
              TextWidgetPrinter(
                text: '${(132)}',
                textAlign: TextAlign.start,
              ),
            ],
          ),


          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgetPrinter(text: 'الشحن', textAlign: TextAlign.start),

                  TextWidgetPrinter(
                    text: 'Shipping',
                    textAlign: TextAlign.start,
                  ),
                ],
              ).expand,
              TextWidgetPrinter(
                text:
                '${12}',
                textAlign: TextAlign.start,
              ),
            ],
          ),


          Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidgetPrinter(
                    text: 'المجموع الكلي',
                    textAlign: TextAlign.start,
                  ),

                  TextWidgetPrinter(text: 'Total', textAlign: TextAlign.start),
                ],
              ).expand,
              TextWidgetPrinter(
                text: '${454}',
                textAlign: TextAlign.start,
              ),
            ],
          ),

          SizedBox(
            height: 150,

          )
        ],
      ),
    );
  }
}

class TextWidgetPrinter extends StatelessWidget {
  const TextWidgetPrinter({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.textAlign,
  });

  final String text;
  final double? fontSize;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign ?? TextAlign.start,
      text,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
