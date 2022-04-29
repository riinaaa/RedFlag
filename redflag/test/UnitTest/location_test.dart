import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

Position get mockPosition => Position(
    latitude: 21.488989,
    longitude: 39.246326,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      800,
      isUtc: true,
    ),
    altitude: 1000,
    accuracy: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0.0);

void main() {
  group('Geolocator', () {
    setUp(() {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
    });
    test('getCurrentPosition', () async {
      final position = await Geolocator.getCurrentPosition();

      Position fake = Position(
          latitude: 21.488989,
          longitude: 39.246326,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            800,
            isUtc: true,
          ),
          altitude: 1000,
          accuracy: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0.0);

      expect(position, fake);
    });
    test('isLocationServiceEnabled', () async {
      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();

      expect(isLocationServiceEnabled, true);
    });

    test('requestPermission', () async {
      final permission = await Geolocator.requestPermission();

      expect(permission, LocationPermission.whileInUse);
    });

    test('getLocationAccuracy', () async {
      final accuracy = await Geolocator.getLocationAccuracy();

      expect(accuracy, LocationAccuracyStatus.precise);
    });
  });
}

class MockGeolocatorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {
  @override
  Future<LocationAccuracyStatus> getLocationAccuracy() =>
      Future.value(LocationAccuracyStatus.precise);

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) =>
      Future.value(mockPosition);

  @override
  Future<LocationPermission> requestPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);
}
