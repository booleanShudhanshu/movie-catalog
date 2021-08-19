import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_catalog/src/model/model_single_movie.dart';

part 'model_movies.g.dart';

@JsonSerializable(explicitToJson: true)
class MoviesModel {
  @JsonKey(name: 'movies')
  List<SingleMovieModel> movies;

  MoviesModel({this.movies});

  factory MoviesModel.fromJson(Map<String, dynamic> json) => _$MoviesModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesModelToJson(this);

  factory MoviesModel.fromFirestore(DocumentSnapshot doc) {
    return MoviesModel.fromJson(doc?.data() ?? {});
  }
}
