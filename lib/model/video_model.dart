

import 'dart:convert';

List<VideoModel> videoModelFromJson(String str) => List<VideoModel>.from(json.decode(str).map((x) => VideoModel.fromJson(x)));

String videoModelToJson(List<VideoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoModel {
  final String? videoId;
  final String? videoFk;
  final String? views;
  final String? videourl;
  final String? rendering;
  final String? thumbnail;
  final String? lastupdate;
  final String? videoLocalTitle;
  final String? videoTitle;

  VideoModel({
    this.videoId,
    this.videoFk,
    this.views,
    this.videourl,
    this.rendering,
    this.thumbnail,
    this.lastupdate,
    this.videoLocalTitle,
    this.videoTitle,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    videoId: json["video_id"],
    videoFk: json["video_fk"],
    views: json["views"],
    videourl: json["videourl"],
    rendering: json["rendering"],
    thumbnail: json["thumbnail"],
    lastupdate: json["lastupdate"],
    videoLocalTitle: json["video_local_title"],
    videoTitle: json["video_title"],
  );


  Map<String, dynamic> toJson() => {
    "video_id": videoId,
    "video_fk": videoFk,
    "views": views,
    "videourl": videourl,
    "rendering": rendering,
    "thumbnail": thumbnail,
    "lastupdate": lastupdate,
    "video_local_title": videoLocalTitle,
    "video_title": videoTitle,
  };
}
