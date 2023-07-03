import 'dart:io';
import 'package:dinstagram/apis/maps_apis.dart';
import 'package:dinstagram/apis/user_apis.dart';
import 'package:dinstagram/models/user_post.dart';
import 'package:dinstagram/presentation/pages/Dashboard/initial_page.dart';
import 'package:dinstagram/presentation/pages/UploadPost/add_location_page.dart';
import 'package:dinstagram/presentation/resources/constants/sizedbox_constants.dart';
import 'package:dinstagram/presentation/resources/themes_manager.dart';
import 'package:dinstagram/utilities/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_posts_provider.dart';
import 'apply_filters_page.dart';

class AddPostDetailsPage extends StatefulWidget {
  final List<ImageFilterFile> images;
  const AddPostDetailsPage({super.key, required this.images});

  @override
  State<AddPostDetailsPage> createState() => _AddPostDetailsPageState();
}

class _AddPostDetailsPageState extends State<AddPostDetailsPage> {
  final _captionController = TextEditingController();

  LatLng? _latLng;

  void setYourLocation(LatLng latlng) {
    _latLng = latlng;
  }

  bool _isLoading = false;
  List<Images> imageUrls = [];

  Future<void> getImageUrls() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    try {
      for (var image in widget.images) {
        await FirebaseStorage.instance
            .ref(
              'posts/$userId/${image.id}',
            )
            .putFile(File(image.id))
            .then((p0) {});

        String imageUrl = await FirebaseStorage.instance
            .ref('posts/$userId/${image.id}')
            .getDownloadURL();
        imageUrls.add(
          Images(
            imageUrl: imageUrl,
            filterName: image.colorFilterModel.filterName,
          ),
        );
      }
    } catch (e) {
      SnackBars.showErrorSnackBar(context, e.toString());
    }
  }

  Future<void> uploadPost() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final postId = DateTime.now().millisecondsSinceEpoch.toString();
      await getImageUrls().then((value) {
        Provider.of<UserPostsProvider>(context, listen: false).addPost(
          UserPostModel(
            id: postId,
            images: imageUrls,
            likes: [],
            bookmarks: [],
            caption: _captionController.text,
            latitude: _latLng == null ? 0 : _latLng!.latitude,
            longitude: _latLng == null ? 0 : _latLng!.longitude,
            userId: UserApis.user!.uid,
          ),
        );
      });

      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushNamedAndRemoveUntil(InitialPage.routename, (route) => false);
      SnackBars.showNormalSnackbar(context, 'Post upload successful.');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      SnackBars.showErrorSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var i in widget.images) {
      print(i.colorFilterModel.filterName);
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  appBar(),
                  Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: Image.file(
                              File(widget.images[0].id),
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (widget.images.length > 1)
                            const Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(
                                Icons.folder_copy_sharp,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: _captionController,
                          cursorColor: Colors.blue,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          minLines: 3,
                          maxLines: 5,
                          decoration: InputDecoration(
                            fillColor:
                                Provider.of<ThemeProvider>(context).isLightTheme
                                    ? Colors.transparent
                                    : null,
                            filled: true,
                            hintText: 'Write a caption...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBoxConstants.sizedboxh5,
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      GoogleMapsApis.determinePosition().then((value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SetLocationPage(
                              setPostLocation: setYourLocation,
                            ),
                          ),
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      }).catchError((e) {
                        SnackBars.showErrorSnackBar(
                            context, 'Something went wrong.');
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      width: double.infinity,
                      child: const Text(
                        'Add Location',
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Provider.of<ThemeProvider>(context).isLightTheme
                                  ? Colors.black12
                                  : const Color.fromARGB(255, 63, 62, 62),
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: const Text(
                          'Use my current location',
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    height: 0,
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            const Text(
              'New Post',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () async {
            await uploadPost();
          },
          icon: const Icon(
            Icons.arrow_forward_outlined,
          ),
        ),
      ],
    );
  }
}
