import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:movie_catalog/src/model/model_movies.dart';
import 'package:movie_catalog/src/model/model_single_movie.dart';
import 'package:movie_catalog/src/service/base_service.dart';
import 'package:movie_catalog/src/utils/constants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class MovieService extends BaseFirebaseService {
  Future<void> saveMovieData(
      {@required SingleMovieModel singleMovieModel,
      @required List<Asset> posterImageFile,
      @required bool isEdit,
      @required movieIndex}) async {
    final moviesModel = await fetchMoviesFromFirebase();
    moviesModel.movies ??= [];
    if (isEdit) {
      moviesModel.movies.removeAt(movieIndex);
    }

    try {
      if (posterImageFile.isNotEmpty) {
        final posterUrl = await uploadImage(posterImageFile[0]);
        singleMovieModel.moviePoster = posterUrl;
      }

      moviesModel.movies.add(singleMovieModel);
      db.collection('movies').doc(user.uid).set(moviesModel.toJson());
      Constants.showToast("Movie Saved Successfully");
    } catch (e) {
      log("IN TRY CATCH: " + e.toString());
    }
  }

  void editMovieData(SingleMovieModel singleMovieModel, String field) async {
    try {
      await db.collection('movies').doc(user.uid).set(
            singleMovieModel.toJson(),
            SetOptions(mergeFields: [field]),
          );
    } catch (e) {
      log("IN TRY CATCH: " + e.toString());
    }
  }

  Future<void> deleteMovie(SingleMovieModel singleMovieModel) async {
    final moviesModel = await fetchMoviesFromFirebase();
    moviesModel.movies.removeWhere((movie) => movie.movieName == singleMovieModel.movieName);
    db.collection('movies').doc(user.uid).set(moviesModel.toJson());
    Constants.showToast("Movie Deleted Successfully");
  }

  Stream<MoviesModel> streamMovies() {
    if (auth.currentUser?.uid == null) return null;
    try {
      Stream<DocumentSnapshot> stream = db.collection('movies').doc(auth.currentUser.uid).snapshots();
      return stream.map((event) => MoviesModel.fromFirestore(event));
    } catch (e) {
      log("IN TRY CATCH: " + e.toString());
    }
    return null;
  }

  Future<MoviesModel> fetchMoviesFromFirebase() async {
    if (auth.currentUser?.uid == null) return null;
    DocumentSnapshot doc = await db.collection('movies').doc(auth.currentUser.uid).get();
    return MoviesModel.fromFirestore(doc);
  }

  Future<String> uploadImage(Asset image) async {
    String _downloadUrl;
    try {
      if (image == null) return null;

      Reference ref = FirebaseStorage.instance
          .ref()
          .child(user.uid)
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      final UploadTask uploadTask = ref.putData((await image.getByteData()).buffer.asUint8List());
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      _downloadUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      Constants.showToast("Error inside upload image: " + e.toString());
    }
    return _downloadUrl;
  }
}
