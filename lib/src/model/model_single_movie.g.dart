// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_single_movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleMovieModel _$SingleMovieModelFromJson(Map<String, dynamic> json) {
  return SingleMovieModel(
    directorName: json['director_name'] as String,
    movieName: json['movie_name'] as String,
    moviePoster: json['movie_poster'] as String,
  );
}

Map<String, dynamic> _$SingleMovieModelToJson(SingleMovieModel instance) =>
    <String, dynamic>{
      'director_name': instance.directorName,
      'movie_name': instance.movieName,
      'movie_poster': instance.moviePoster,
    };
