import 'package:json_annotation/json_annotation.dart';

part 'testList.g.dart';

@JsonSerializable()
class TestList {
    TestList();

    String name;
    num id;
    
    factory TestList.fromJson(Map<String,dynamic> json) => _$TestListFromJson(json);
    Map<String, dynamic> toJson() => _$TestListToJson(this);
}
