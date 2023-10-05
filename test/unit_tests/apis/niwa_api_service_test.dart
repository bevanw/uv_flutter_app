import 'dart:convert';

import 'package:fluent_assertions/fluent_assertions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:uv_flutter_app/apis/niwa/models/skye_types.dart';
import 'package:uv_flutter_app/apis/niwa/niwa_api_service.dart';
import 'package:xml/xml.dart';

void main() {
  group('NIWA APIs', () {
    test('uv index should be returned', () async {
      var clientMock = MockClient((request) async {
        return Response(XmlDocument.parse('''<svg
          xmlns="http://www.w3.org/2000/svg" width="400" height="600">
          <text y="220" text-anchor="middle" font-size="1.2em" font-family="Roboto, sans-serif">
            <tspan class="location" text-anchor="middle" dy="1.1em" x="200">-37.0, 175.0</tspan>
            <tspan class="data-type" text-anchor="middle" dy="1.1em" x="200">CURRENT UVI for cloudy skies</tspan>
            <tspan class="value" text-anchor="middle" dy="1.1em" x="200">12 at Oct 1st 9:00 pm</tspan>
          </text>
        </svg>''').toString(), 200);
      });

      final niwaApiService = NiwaApiService(clientMock, "");

      final uvIndex = await niwaApiService.fetchUVIndex(1, 1, SkyTypes.clear);

      uvIndex.shouldNotBeNull();
      uvIndex.value.shouldBeEqualTo(12);
    });

    test('uv forecast should be returned', () async {
      var clientMock = MockClient((request) async {
        return Response(
            jsonEncode({
              "coord": "EPSG:4326,-39.0,174.0",
              "products": [
                {
                  "name": "clear_sky_uv_index",
                  "values": [
                    {"time": "2022-01-16T00:00:00.000Z", "value": 12.2892},
                    {"time": "2022-01-16T01:00:00.000Z", "value": 13.6843}
                  ]
                },
                {
                  "name": "cloudy_sky_uv_index",
                  "values": [
                    {"time": "2022-01-16T00:00:00.000Z", "value": 11.2901},
                    {"time": "2022-01-16T01:00:00.000Z", "value": 7.1334},
                    {"time": "2022-01-16T02:00:00.000Z", "value": 6.4564}
                  ]
                }
              ]
            }),
            200);
      });

      final niwaApiService = NiwaApiService(clientMock, "");

      final uVForecast = await niwaApiService.fetchUVForecast(1, 1);

      uVForecast.shouldNotBeNull();
      uVForecast.clearSky.length.shouldBeEqualTo(2);
      uVForecast.cloudySky.length.shouldBeEqualTo(3);
    });
  });
}
