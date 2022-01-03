import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoomicar/constants/app_constants.dart';
import '/models/mechanic.dart';
import '/models/problem_model.dart';
import '/screens/map/map_screen.dart';
import '/screens/mechanic_details/widget/rating_bar.dart';
import '../../constants/api_keys.dart';
import 'package:url_launcher/url_launcher.dart';

class MechanicDetailsScreen extends StatelessWidget {
  // static const String routeName = '/mechanic details';
  final Mechanic mechanic;
  final CustomLocation location;

  // ignore: use_key_in_widget_constructors
  const MechanicDetailsScreen({required this.mechanic, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            stretch: true,
            elevation: 4,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            iconTheme: const IconThemeData(color: Colors.white),
            expandedHeight: 250.0,
            excludeHeaderSemantics: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              centerTitle: true,
              title: Text(
                mechanic.name,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        blurRadius: 1,
                        offset: shadowOffset,
                        color: Colors.black38)
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(color: Colors.white60),
                  CachedNetworkImage(
                    imageUrl: baseUrl + mechanic.image,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) {
                      return Center(
                        child:
                            CircularProgressIndicator(value: progress.progress),
                      );
                    },
                    errorWidget: (context, url, error) => Center(
                      child: SvgPicture.asset(
                        'assets/icons/image-not-found.svg',
                        width: MediaQuery.of(context).size.width * 0.35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0x90000000),
                          Colors.transparent,
                          Colors.transparent,
                          Color(0x20000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                _buildCapabilities(),
                _buildRow(
                  leading: 'نام مرکز',
                  trailing: mechanic.name,
                ),
                const Divider(thickness: 1),
                _buildRow(
                  leading: 'فاصله',
                  trailing:
                      '${mechanic.getDistance(location).toStringAsFixed(1)} کیلومتر',
                ),
                const Divider(thickness: 1),
                _buildRow(
                  leading: 'شماره تلفن',
                  trailing: mechanic.phoneNumber,
                ),
                const Divider(thickness: 1),
                //* Descriptions
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'توضیحات',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(mechanic.description),
                ),
                const Divider(thickness: 1),
                //* RatingBar
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'ثبت امتیاز',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                CustomRatingBar(
                  id: mechanic.id,
                  initialRating: mechanic.userRate,
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                child: const Text('تماس'),
                // child: Text('Call  ${mechanic.phoneNumber}'),
                onPressed: () async {
                  launch('tel:' + mechanic.phoneNumber);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: OutlinedButton(
                child: const Text('مکان روی نقشه'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MapScreen(
                        location: mechanic.location,
                        mechanic: mechanic,
                      );
                    },
                  ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({required String leading, required String trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(leading, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(trailing),
        ],
      ),
    );
  }

  Widget _buildCapabilities() {
    return IntrinsicHeight(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _capability(
              icon: const Icon(Icons.car_repair),
              text: const Text('تعمیر خودرو'),
            ),
            ...mechanic.tags.map((tag) {
              return _capability(
                icon: Image.asset(
                  tagToAsset(tag),
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.miscellaneous_services),
                ),
                text: Text(tagToTitle(tag)),
              );
            }),
          ]
              .expand((element) => [
                    element,
                    const VerticalDivider(
                      thickness: 1,
                      width: 32,
                      indent: 4,
                      endIndent: 4,
                    )
                  ])
              .toList(),
        ),
      ),
    );
  }

  Widget _capability({required Widget icon, required Widget text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [icon, const Spacer(), text],
    );
  }
}
