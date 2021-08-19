import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_single_movie.g.dart';

@JsonSerializable(explicitToJson: true)
class SingleMovieModel {
  @JsonKey(name: 'director_name')
  String directorName;

  @JsonKey(name: 'movie_name')
  String movieName;

  @JsonKey(name: 'movie_poster')
  String moviePoster;

  SingleMovieModel({this.directorName, this.movieName, this.moviePoster});

  factory SingleMovieModel.fromJson(Map<String, dynamic> json) => _$SingleMovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$SingleMovieModelToJson(this);

  factory SingleMovieModel.fromFirestore(DocumentSnapshot doc) {
    return SingleMovieModel.fromJson(doc?.data() ?? {});
  }
}
