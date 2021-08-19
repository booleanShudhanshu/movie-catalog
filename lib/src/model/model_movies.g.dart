// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_movies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoviesModel _$MoviesModelFromJson(Map<String, dynamic> json) {
  return MoviesModel(
    movies: (json['movies'] as List)
        ?.map((e) => e == null
            ? null
            : SingleMovieModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MoviesModelToJson(MoviesModel instance) =>
    <String, dynamic>{
      'movies': instance.movies?.map((e) => e?.toJson())?.toList(),
    };
