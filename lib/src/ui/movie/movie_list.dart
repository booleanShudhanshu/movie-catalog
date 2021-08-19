import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/page_transition_type.dart';
import 'package:movie_catalog/src/app.dart';
import 'package:movie_catalog/src/model/model_movies.dart';
import 'package:movie_catalog/src/model/model_single_movie.dart';
import 'package:movie_catalog/src/ui/movie/add_movie.dart';
import 'package:movie_catalog/src/utils/constants.dart';
import 'package:movie_catalog/src/utils/routes.dart';
import 'package:movie_catalog/src/widgets/domino_reveal.dart';
import 'package:provider/provider.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key key}) : super(key: key);
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  MoviesModel moviesModel;

  @override
  Widget build(BuildContext context) {
    moviesModel = Provider.of<MoviesModel>(context);
    return moviesModel != null
        ? Scaffold(
            floatingActionButton: _addMovieOnTapHandle(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            extendBodyBehindAppBar: true,
            appBar:
                AppBar(title: Text('Movies'), elevation: 0, backgroundColor: Colors.black54, actions: [
              IconButton(
                  onPressed: () async {
                    Navigator.of(context).push(createRoute(MyApp(), PageTransitionType.slideLeft));
                    await FirebaseAuth.instance.signOut();
                  },
                  icon: Icon(Icons.logout, color: Colors.green)),
            ]),
            // floatingActionButton: _addMovieOnTapHandle(),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            backgroundColor: Colors.black,
            body: _body(),
          )
        : customProgressIndicator();
  }

  Widget _body() {
    return moviesModel.movies != null
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 80),
            itemCount: moviesModel.movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: DominoReveal(child: _movieCard(index)),
              );
            })
        : Center(
            child: Text(
              "You don't have any movie here.\nPlease add one in catalog.",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: MONTSERRAT, color: Colors.white),
            ),
          );
  }

  Widget _addMovieOnTapHandle() {
    return MaterialButton(
        color: Colors.green,
        onPressed: () {
          Navigator.of(context)
              .push(createRoute(AddMovieScreen(isFromEdit: false), PageTransitionType.slideLeft));
        },
        child: Text('Add Movie', style: TextStyle(fontFamily: MONTSERRAT, color: Colors.white)));
  }

  Widget _movieCard(int index) {
    final movieItem = moviesModel.movies[index];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(createRoute(
            AddMovieScreen(isFromEdit: true, singleMovieModel: movieItem, movieIndex: index),
            PageTransitionType.slideParallaxLeft));
      },
      child: SizedBox(
        height: Constants.screenSize(context).height * 0.2,
        child: Stack(
          children: [
            Positioned(bottom: 0, right: 0, left: 0, child: _backgroundCard(movieItem.moviePoster)),
            _gradient(),
            Positioned(bottom: 0, right: 0, child: _basicDetail(movieItem))
          ],
        ),
      ),
    );
  }

  Widget _backgroundCard(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      width: Constants.screenSize(context).width * 0.9,
      height: Constants.screenSize(context).height * 0.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          width: Constants.screenSize(context).width * 0.28,
          height: Constants.screenSize(context).height * 0.2,
          placeholder: (context, url) => Container(color: Colors.grey[900]),
          imageUrl: url ??
              'https://d2kektcjb0ajja.cloudfront.net/images/posts/feature_images/000/000/072/large-1466557422-feature.jpg?1466557422',
          fit: BoxFit.cover,
          fadeInCurve: Curves.easeIn,
          fadeInDuration: Duration(microseconds: 1000),
        ),
      ),
    );
  }

  Widget _basicDetail(SingleMovieModel singleMovieItem) {
    return Container(
        width: Constants.screenSize(context).width * 0.9,
        height: Constants.screenSize(context).height * 0.2,
        child: Padding(
          padding: EdgeInsets.only(left: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(singleMovieItem.movieName),
              const SizedBox(height: 4),
              _popularity(singleMovieItem.directorName),
            ],
          ),
        ));
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Text(
        title.toUpperCase(),
        maxLines: 2,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: IMPACT,
        ),
      ),
    );
  }

  Widget _popularity(String directorName) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Director: ',
            style: TextStyle(fontWeight: FontWeight.w700, fontFamily: MONTSERRAT, color: Colors.white),
          ),
          Container(
              child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child:
                Text(directorName.trim(), style: TextStyle(fontFamily: MONTSERRAT, color: Colors.white)),
          ))
        ],
      ),
    );
  }

  Widget _gradient() {
    return Container(
      width: Constants.screenSize(context).width * 0.9,
      height: Constants.screenSize(context).height * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black87, Colors.transparent],
              stops: [0.1, 1.0])),
    );
  }
}
