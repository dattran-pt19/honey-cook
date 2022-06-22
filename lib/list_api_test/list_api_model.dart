import 'package:honey_cook/base/base_codable.dart';

class ApiModel extends Encodable {
  final userId = Interger(key: 'userId');
  final id = Interger(key: 'id');
  final title = Stringer(key: 'title');
  final body = Stringer(key: 'body');

  @override
  List<OriginalCodable> properties() {
    return [userId, id, title, body];
  }
}