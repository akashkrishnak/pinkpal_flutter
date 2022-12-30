import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as Latlng;
import 'logged_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map/map.dart';

class location extends StatefulWidget {
  const location({super.key});

  @override
  State<location> createState() => _locationState();
}
// final controller = MapController(
//   location:const LatLng(logged_inState.latitude,logged_inState.longitude),
//   zoom: 2,
// );
class _locationState extends State<location> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Pal",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
        ),
        body: Center(
//           child:MapLayout(
//   controller: controller,
//   builder: (context, transformer) {
//     return TileLayer(
//       builder: (context, x, y, z) {
//         final tilesInZoom = pow(2.0, z).floor();

//         while (x < 0) {
//           x += tilesInZoom;
//         }
//         while (y < 0) {
//           y += tilesInZoom;
//         }

//         x %= tilesInZoom;
//         y %= tilesInZoom;

//         //Google Maps
//         final url =
//             'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

//         return Column(
//           children: [],
//         );
//       },
//     );
//   },
// )
        ),
      ),
    );
  }
}