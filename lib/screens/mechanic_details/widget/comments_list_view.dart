import 'package:flutter/material.dart';
import 'package:zoomicar/constants/app_constants.dart';
import 'package:zoomicar/models/rate.dart';
import 'package:zoomicar/utils/services/mechanic_rate_service.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CommentsListView extends StatefulWidget {
  const CommentsListView({Key? key, required this.rateService})
      : super(key: key);

  final MechanicRateService rateService;

  @override
  State<CommentsListView> createState() => _CommentsListViewState();
}

class _CommentsListViewState extends State<CommentsListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      child: FutureBuilder<List<Rate>>(
          future: widget.rateService.getCenterRates(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _buildContainer(
                  child: Column(
                children: [
                  const Text('اتصال برقرار نیست'),
                  TextButton.icon(
                    onPressed: () => setState(() {}),
                    label: const Text('تلاش مجدد'),
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final List<Rate> rates = snapshot.data ?? [];
              final items = rates.where((element) => element.text.isNotEmpty);
              if (items.isEmpty) {
                return _buildContainer(
                    child: const Text('هنوز نظری ثبت نشده است.'));
              }
              return Column(
                children: items.map((rate) => _buildCommentItem(rate)).toList(),
              );
            }
            return _buildContainer(child: const Text('اتصال برقرار نیست'));
          }),
    );
  }

  Widget _buildCommentItem(Rate rate) {
    final date = Jalali.fromDateTime(rate.time);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                rate.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${date.year}/${date.month}/${date.day}',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          Text(rate.text),
          Row(
            children: [
              const Spacer(),
              _buildStars(rate.rate),
            ],
          ),
          const Divider(thickness: 1, height: 24),
        ],
      ),
    );
  }

  Widget _buildStars(double rateNumber) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rateNumber ? Icons.star_rounded : Icons.star_border_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildContainer({required Widget child}) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: customContainerBorder,
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
        child: Center(child: child),
      );
}
