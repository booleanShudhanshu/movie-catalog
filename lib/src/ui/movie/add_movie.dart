import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_catalog/src/model/model_single_movie.dart';
import 'package:movie_catalog/src/service/movie_service.dart';
import 'package:movie_catalog/src/utils/constants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddMovieScreen extends StatefulWidget {
  final bool isFromEdit;
  final int movieIndex;
  final SingleMovieModel singleMovieModel;
  const AddMovieScreen({Key key, @required this.isFromEdit, this.singleMovieModel, this.movieIndex})
      : super(key: key);

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  TextEditingController directornameController;
  TextEditingController movieNamecontroller;
  // Value of imageUrl will be null in cases other than edit.
  String imageUrl;

  // This is used while adding movie
  List<Asset> posterImagefile = <Asset>[];

  Future<void> loadAssets() async {
    posterImagefile.clear();
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: posterImagefile,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitle: "Movie Catalog",
          actionBarTitleColor: "#ffffff",
          allViewTitle: "All Photos",
          useDetailsView: true,
          selectCircleStrokeColor: "#ffffff",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print("Error in load assets $error");
    }
    if (!mounted) return;
    setState(() {
      posterImagefile = resultList;
    });
  }

  @override
  void initState() {
    directornameController = TextEditingController(text: widget.singleMovieModel?.directorName ?? '');
    movieNamecontroller = TextEditingController(text: widget.singleMovieModel?.movieName ?? '');
    if (widget.isFromEdit) {
      imageUrl = widget.singleMovieModel.moviePoster;
    }

    super.initState();
  }

  @override
  void dispose() {
    directornameController.dispose();
    movieNamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.isFromEdit ? "Edit Movie" : "Add Movie"),
          actions: widget.isFromEdit ? [_deleteButton()] : []),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 54),
            widget.isFromEdit && posterImagefile.isEmpty ? getCachedNetworkImageWidget() : _addImage(),
            SizedBox(height: 54),
            _textField(movieNamecontroller, 'movie name'),
            SizedBox(height: 24),
            _textField(directornameController, 'director name'),
            const Expanded(child: SizedBox.shrink()),
            _saveButton()
          ],
        ),
      ),
    );
  }

  Widget _addImage() {
    return InkWell(
      onTap: () {
        loadAssets();
      },
      child: posterImagefile.isEmpty
          ? Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(child: Icon(Icons.add_a_photo_rounded, color: Colors.white)),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AssetThumb(
                asset: posterImagefile[0],
                width: 124,
                height: 124,
                quality: 100,
              )),
    );
  }

  Widget getCachedNetworkImageWidget() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            loadAssets();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: imageUrl,
              width: Constants.screenSize(context).width * 0.9,
              height: Constants.screenSize(context).height * 0.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text("Note: Click on the image to edit", style: TextStyle(fontSize: 13))
      ],
    );
  }

  Widget _deleteButton() {
    return IconButton(
      onPressed: () {
        MovieService().deleteMovie(widget.singleMovieModel);
        Constants.showToast("Movie Deletion: In Progress");
        Navigator.pop(context);
      },
      icon: Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _saveButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashFactory: InkRipple.splashFactory,
      onTap: () {
        if (validate()) {
          _parseAndSaveMovieToFirebase();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text("Save",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: MONTSERRAT)),
            ),
          ),
        ),
      ),
    );
  }

  void _parseAndSaveMovieToFirebase() {
    final singleMovieItem = new SingleMovieModel();
    singleMovieItem.directorName = directornameController.text.toString();
    singleMovieItem.movieName = movieNamecontroller.text.toString();
    singleMovieItem.moviePoster = imageUrl;
    MovieService().saveMovieData(
        singleMovieModel: singleMovieItem,
        posterImageFile: posterImagefile,
        isEdit: widget.isFromEdit,
        movieIndex: widget.movieIndex);
    Constants.showToast("Movie Upload: In Progress");
    Navigator.pop(context);
  }

  bool validate() {
    if (widget.isFromEdit) {
      if (directornameController.text.toString().trim().isEmpty ||
          movieNamecontroller.text.toString().trim().isEmpty) {
        Constants.showToast("All Fields Are Mandatory!");
        return false;
      }
    } else if (directornameController.text.toString().trim().isEmpty ||
        movieNamecontroller.text.toString().trim().isEmpty ||
        posterImagefile.isEmpty) {
      Constants.showToast("All Fields Are Mandatory!");
      return false;
    }
    return true;
  }

  Widget _textField(TextEditingController controller, String hintText) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        cursorColor: Colors.white,
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
            border: InputBorder.none,
            hintText: hintText,
            fillColor: Colors.grey[900],
            filled: true),
      ),
    );
  }
}
