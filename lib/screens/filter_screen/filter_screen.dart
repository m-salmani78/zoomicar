import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomicar/models/problem_model.dart';
import 'package:zoomicar/utils/services/mechanic_filter_provider.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MechanicsFilterProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('فیلتر ها'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: () {
              provider.deleteAllTags();
              provider.deleteRangeDistanceFilter();
            },
            child: Text('حذف فیلترها',
                style: Theme.of(context).textTheme.overline),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        children: [
          const Text(
            'محدوده فاصله:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _buildRangeDistanceFilter(provider),
          const Divider(indent: 8, endIndent: 8),
          Row(
            children: [
              const Text(
                'انواع خدمات:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Text('همه'),
              Checkbox(
                tristate: true,
                value: provider.filterTags.length == tags.length
                    ? true
                    : provider.filterTags.isEmpty
                        ? false
                        : null,
                onChanged: (value) {
                  log('$value');
                  if (value == true) {
                    for (var tag in tags) {
                      provider.addTagFilter(tag);
                    }
                  } else {
                    provider.deleteAllTags();
                  }
                },
              ),
            ],
          ),
          _buildTagsFilter(provider)
        ],
      ),
    );
  }

  Widget _buildRangeDistanceFilter(MechanicsFilterProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('$minDistance کیلومتر'),
            Text('تا'),
            Text('$maxDistance کیلومتر')
          ],
        ),
        RangeSlider(
          min: minDistance.toDouble(),
          max: maxDistance.toDouble(),
          values: provider.rangeDistance,
          onChanged: (value) => provider.changeRangeDistanceFilter(value),
          divisions: 100,
          labels: RangeLabels(
            '${provider.rangeDistance.start.toInt()}',
            '${provider.rangeDistance.end.toInt()}',
          ),
        ),
      ],
    );
  }

  Widget _buildTagsFilter(MechanicsFilterProvider provider) {
    return Column(
      children: tags.map((tag) {
        return CheckboxListTile(
          value: provider.filterTags.contains(tag),
          onChanged: (value) {
            if (value == true) {
              provider.addTagFilter(tag);
            } else {
              provider.deleteTagFilter(tag);
            }
          },
          title: Text(tagToTitle(tag)),
        );
      }).toList(),
    );
  }
}
