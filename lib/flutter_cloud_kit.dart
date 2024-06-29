import 'package:flutter_cloud_kit/types/cloud_kit_record.dart';
import 'package:flutter_cloud_kit/types/cloud_kit_account_status.dart';
import 'package:flutter_cloud_kit/types/database_scope.dart';
import 'flutter_cloud_kit_platform_interface.dart';

final _cloudKitIdentifierRegexp = RegExp(r'^[a-zA-Z]\w+$');
final _letterRegexp = RegExp(r'^[a-zA-Z]$');

void validateCloudKitIdentifier(String identifier) {
  bool isValidIdentifier = _letterRegexp.hasMatch(identifier) ||
      _cloudKitIdentifierRegexp.hasMatch(identifier);
  if (!isValidIdentifier) {
    throw Exception('Identifier "$identifier" is not valid for cloud kit');
  }
}

class FlutterCloudKit {
  final String? containerId;

  FlutterCloudKit({this.containerId});

  Future<CloudKitAccountStatus> getAccountStatus() {
    return FlutterCloudKitPlatform.instance
        .getAccountStatus(containerId: containerId);
  }

  Future<void> saveRecord({
    required CloudKitDatabaseScope scope,
    required String recordType,
    required Map<String, dynamic> record,
    String? recordName,
  }) {
    validateCloudKitIdentifier(recordType);
    record.keys.forEach(validateCloudKitIdentifier);
    return FlutterCloudKitPlatform.instance.saveRecord(
      containerId: containerId,
      scope: scope,
      recordType: recordType,
      record: record,
      recordName: recordName,
    );
  }

  Future<CloudKitRecord> getRecord({
    required CloudKitDatabaseScope scope,
    required String recordName,
  }) {
    return FlutterCloudKitPlatform.instance.getRecord(
      containerId: containerId,
      scope: scope,
      recordName: recordName,
    );
  }

  Future<List<CloudKitRecord>> getRecordsByType({
    required CloudKitDatabaseScope scope,
    required String recordType,
  }) {
    return FlutterCloudKitPlatform.instance.getRecordsByType(
      containerId: containerId,
      scope: scope,
      recordType: recordType,
    );
  }

  Future<void> deleteRecord({
    required CloudKitDatabaseScope scope,
    required String recordName,
  }) {
    return FlutterCloudKitPlatform.instance.deleteRecord(
      containerId: containerId,
      scope: scope,
      recordName: recordName,
    );
  }
}
