import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:zoomicar/constants/app_constants.dart';
import 'package:zoomicar/screens/mechanic_details/widget/send_comment_screen.dart';
import 'package:zoomicar/utils/services/mechanic_rate_service.dart';

class YourRateView extends StatefulWidget {
  final MechanicRateService rateService;

  const YourRateView({required this.rateService});

  @override
  _YourRateViewState createState() => _YourRateViewState();
}

class _YourRateViewState extends State<YourRateView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: customCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          buildRatingBar(
            context,
            initialRating: widget.rateService.rate.toDouble(),
            onRatingUpdate: (value) async {
              widget.rateService.rate = value.toInt();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SendCommentMenu(rateService: widget.rateService),
                ),
              );
              if (result == true) setState(() {});
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.overline,
                      ),
                    )),
          ),
          widget.rateService.text.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(minHeight: 80),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cornerRadius),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Text(widget.rateService.text),
                )
              : const SizedBox(height: 8),
          const SizedBox(height: 4),
          Divider(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 6,
              thickness: 6),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              child: Text(
                  '${widget.rateService.text.isEmpty ? 'افزودن' : 'ویرایش'} نظر',
                  style: const TextStyle(height: 2)),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SendCommentMenu(rateService: widget.rateService),
                  ),
                );
                if (result == true) setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildRatingBar(BuildContext context,
    {required double initialRating,
    required void Function(double value) onRatingUpdate}) {
  final color = Theme.of(context).colorScheme.primary;
  return RatingBar(
    wrapAlignment: WrapAlignment.spaceAround,
    glow: false,
    itemCount: 5,
    initialRating: initialRating,
    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
    unratedColor: Colors.grey[400],
    ratingWidget: RatingWidget(
      full: Icon(Icons.star_rounded, color: color),
      half: Icon(Icons.star_half_rounded,
          textDirection: TextDirection.ltr, color: color),
      empty: const Icon(Icons.star_border_rounded, color: Colors.grey),
    ),
    onRatingUpdate: onRatingUpdate,
  );
}
