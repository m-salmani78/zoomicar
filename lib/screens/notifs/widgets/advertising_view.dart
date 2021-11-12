import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../constants/api_keys.dart';

class AdvertisingView extends StatefulWidget {
  const AdvertisingView({Key? key}) : super(key: key);

  @override
  _AdvertisingViewState createState() => _AdvertisingViewState();
}

class _AdvertisingViewState extends State<AdvertisingView> {
  bool showAdvertising = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.get(Uri.parse(baseUrl + '/car/advertises')),
      builder: (context, snapshot) {
        if (showAdvertising &&
            !snapshot.hasError &&
            snapshot.connectionState == ConnectionState.done) {
          final response = snapshot.data as http.Response;
          log('@ advertise: ' + response.body);
          if (response.statusCode == 200) {
            try {
              Map<String, dynamic> json =
                  jsonDecode(utf8.decode(response.bodyBytes))[0];
              return Container(
                child: _buildGif(gifUrl: json["gif"], link: json["link"]),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1),
                    offset: const Offset(0, 12),
                    spreadRadius: 3,
                    blurRadius: 12,
                  ),
                ]),
              );
            } catch (e) {
              log('@ E: Advertise Error decoding.');
            }
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildGif({required String link, required String gifUrl}) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            await canLaunch(link)
                ? await launch(link)
                : log('Could not launch $link');
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: width / 4),
            child: Image.network(
              baseUrl + gifUrl,
              width: width,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => setState(() => showAdvertising = false),
            child: Container(
                child: const Icon(Icons.close, color: Colors.white),
                color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
