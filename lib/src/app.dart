import 'package:flutter/material.dart';
import 'package:movie_catalog/src/model/model_movies.dart';
import 'package:movie_catalog/src/service/movie_service.dart';
import 'package:movie_catalog/src/ui/onBoard/splash_screen.dart';
import 'package:movie_catalog/src/utils/constants.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
      fontFamily: MONTSERRAT,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      backgroundColor: Colors.black,
      accentColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
    return MultiProvider(
      providers: [
        StreamProvider<MoviesModel>(
          create: (context) => MovieService().streamMovies(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        theme: theme,
        home: SplashScreen(),
      ),
    );
  }
}
