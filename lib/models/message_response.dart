// To parse this JSON data, do
//
//     final messageResponse = messageResponseFromJson(jsonString);

import 'dart:convert';

MessageResponse messageResponseFromJson(String str) =>
    MessageResponse.fromJson(json.decode(str));

String messageResponseToJson(MessageResponse data) =>
    json.encode(data.toJson());

class MessageResponse {
  MessageResponse({
    this.ok,
    this.msg,
    this.type
  });

  String ok;
  List<Msg> msg;
  int type;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        ok: json["ok"],
        msg: List<Msg>.from(json["msg"].map((x) => Msg.fromJson(x))),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": List<dynamic>.from(msg.map((x) => x.toJson())),
        "type": type
      };
}

class Msg {
  Msg({
    this.from,
    this.to,
    this.msg,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  String from;
  String to;
  String msg;
  int type;
  DateTime createdAt;
  DateTime updatedAt;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        from: json["from"],
        to: json["to"],
        msg: json["msg"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "msg": msg,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
