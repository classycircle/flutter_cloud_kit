import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cloud_kit/types/cloud_kit_record.dart';
import 'package:flutter_cloud_kit/types/cloud_kit_account_status.dart';
import 'package:flutter_cloud_kit/types/database_scope.dart';
import 'flutter_cloud_kit_platform_interface.dart';

class MethodChannelFlutterCloudKit extends FlutterCloudKitPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('app.fuelet.flutter_cloud_kit');

  @override
  Future<CloudKitAccountStatus> getAccountStatus({String? containerId}) async {
    final args = containerId == null ? {} : {'containerId': containerId};
    int rawStatus = await methodChannel.invokeMethod('getAccountStatus', args);
    try {
      return CloudKitAccountStatus.values[rawStatus];
    } catch (_) {
      return CloudKitAccountStatus.unknown;
    }
  }

  @override
  Future<void> saveRecord({
    String? containerId,
    required CloudKitDatabaseScope scope,
    required String recordType,
    required Map<String, dynamic> record,
    String? recordName,
  }) async {
    var args = {
      'databaseScope': scope.name,
      'recordType': recordType,
      'record': record,
    };
    if (containerId != null) {
      args['containerId'] = containerId;
    }
    if (recordName != null) {
      args['recordName'] = recordName;
    }

    // Log the arguments before invoking the method
    args.forEach((key, value) {
      print('Argument $key: value = $value, type = ${value.runtimeType}');
    });

    // Try-catch to log potential method channel invocation errors
    try {
      await methodChannel.invokeMethod('saveRecord', args);
      print('Method channel invokeMethod successful');
    } catch (e) {
      print('Method channel invokeMethod error: $e');
    }
  }

  @override
  Future<CloudKitRecord> getRecord({
    String? containerId,
    required CloudKitDatabaseScope scope,
    required String recordName,
  }) async {
    var args = {
      'databaseScope': scope.name,
      'recordName': recordName,
    };
    if (containerId != null) {
      args['containerId'] = containerId;
    }
    Map<Object?, Object?> result =
        await methodChannel.invokeMethod('getRecord', args);

    return CloudKitRecord.fromMap(Map<String, dynamic>.from(result));
  }

  @override
  Future<List<CloudKitRecord>> getRecordsByType({
    String? containerId,
    required CloudKitDatabaseScope scope,
    required String recordType,
  }) async {
    var args = {
      'databaseScope': scope.name,
      'recordType': recordType,
    };
    if (containerId != null) {
      args['containerId'] = containerId;
    }

    List<Object?> result =
        await methodChannel.invokeMethod('getRecordsByType', args);

    try {
      return result
          .map((e) => Map<String, dynamic>.from(e as Map))
          .map(CloudKitRecord.fromMap)
          .toList();
    } catch (e) {
      throw Exception('Cannot parse cloud kit response: $e');
    }
  }

  @override
  Future<void> deleteRecord({
    String? containerId,
    required CloudKitDatabaseScope scope,
    required String recordName,
  }) async {
    var args = {
      'databaseScope': scope.name,
      'recordName': recordName,
    };
    if (containerId != null) {
      args['containerId'] = containerId;
    }
    await methodChannel.invokeMethod('deleteRecord', args);
  }
}
