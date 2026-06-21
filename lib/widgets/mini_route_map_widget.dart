import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MiniRouteMapWidget extends StatefulWidget {
  final LatLng? pointA;
  final LatLng? pointB;
  final String labelA;
  final String labelB;
  final VoidCallback onEditA;
  final VoidCallback? onEditB;
  final double height;

  const MiniRouteMapWidget({
    super.key,
    required this.pointA,
    this.pointB,
    this.labelA = 'Titik A',
    this.labelB = 'Titik B',
    required this.onEditA,
    this.onEditB,
    this.height = 210,
  });

  @override
  State<MiniRouteMapWidget> createState() => _MiniRouteMapWidgetState();
}

class _MiniRouteMapWidgetState extends State<MiniRouteMapWidget> {
  final MapController _mc = MapController();
  List<LatLng> _routePoints = [];
  bool _loadingRoute = false;

  @override
  void initState() {
    super.initState();
    if (widget.pointA != null && widget.pointB != null) _fetchRoute();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitMap());
  }

  @override
  void didUpdateWidget(MiniRouteMapWidget old) {
    super.didUpdateWidget(old);
    final aChanged = old.pointA != widget.pointA;
    final bChanged = old.pointB != widget.pointB;
    if (aChanged || bChanged) {
      if (widget.pointA != null && widget.pointB != null) {
        _fetchRoute();
      } else {
        setState(() => _routePoints = []);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _fitMap());
    }
  }

  void _fitMap() {
    if (!mounted) return;
    try {
      if (widget.pointA != null && widget.pointB != null) {
        final a = widget.pointA!;
        final b = widget.pointB!;
        final pad = 0.006;
        _mc.fitCamera(CameraFit.bounds(
          bounds: LatLngBounds(
            LatLng(min(a.latitude, b.latitude) - pad, min(a.longitude, b.longitude) - pad),
            LatLng(max(a.latitude, b.latitude) + pad, max(a.longitude, b.longitude) + pad),
          ),
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 56),
        ));
      } else if (widget.pointA != null) {
        _mc.move(widget.pointA!, 15.5);
      }
    } catch (_) {}
  }

  Future<void> _fetchRoute() async {
    final a = widget.pointA!;
    final b = widget.pointB!;
    setState(() => _loadingRoute = true);
    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${a.longitude},${a.latitude};${b.longitude},${b.latitude}?overview=full&geometries=geojson',
      );
      final res = await http.get(url).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final routes = data['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final coords = routes[0]['geometry']['coordinates'] as List;
          if (mounted) {
            setState(() {
              _routePoints = coords.map((c) => LatLng(c[1] as double, c[0] as double)).toList();
              _loadingRoute = false;
            });
          }
          return;
        }
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _routePoints = [a, b];
        _loadingRoute = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pointA == null) return const SizedBox.shrink();

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 6)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Peta (non-interactive di dalam form)
          IgnorePointer(
            child: FlutterMap(
              mapController: _mc,
              options: MapOptions(initialCenter: widget.pointA!, initialZoom: 15),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.bantai_eas',
                ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(polylines: [
                    Polyline(points: _routePoints, strokeWidth: 4.5, color: const Color(0xFF0288D1)),
                  ]),
                MarkerLayer(markers: [
                  Marker(
                    point: widget.pointA!,
                    width: 70,
                    height: 50,
                    alignment: Alignment.topCenter,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFF0288D1), borderRadius: BorderRadius.circular(6)),
                        child: Text(widget.labelA, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                      const Icon(Icons.location_on, color: Color(0xFF0288D1), size: 22),
                    ]),
                  ),
                  if (widget.pointB != null)
                    Marker(
                      point: widget.pointB!,
                      width: 70,
                      height: 50,
                      alignment: Alignment.topCenter,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(6)),
                          child: Text(widget.labelB, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                        ),
                        Icon(Icons.location_on, color: Colors.red.shade600, size: 22),
                      ]),
                    ),
                ]),
              ],
            ),
          ),

          // Loading rute
          if (_loadingRoute)
            Positioned(
              top: 8, right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0288D1))),
              ),
            ),

          // Bottom bar — tombol "Ubah"
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              color: Colors.white.withValues(alpha: 0.93),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.onEditA,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.edit_location_alt_outlined, size: 13, color: Color(0xFF0288D1)),
                          const SizedBox(width: 4),
                          Text('Ubah ${widget.labelA}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0288D1))),
                        ]),
                      ),
                    ),
                  ),
                  if (widget.onEditB != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onEditB,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.edit_location_alt_outlined, size: 13, color: Colors.red.shade500),
                            const SizedBox(width: 4),
                            Text('Ubah ${widget.labelB}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.red.shade500)),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
