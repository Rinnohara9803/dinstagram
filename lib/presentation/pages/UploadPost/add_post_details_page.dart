import 'dart:io';
import 'package:flutter/material.dart';
import 'apply_filters_page.dart';

class AddPostDetailsPage extends StatefulWidget {
  final List<ImageFilterFile> images;
  const AddPostDetailsPage({super.key, required this.images});

  @override
  State<AddPostDetailsPage> createState() => _AddPostDetailsPageState();
}

class _AddPostDetailsPageState extends State<AddPostDetailsPage> {
  final _captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          child: Column(
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
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
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
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              InkWell(
                onTap: () {
                  print('add location');
                  // add location
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 63, 62, 62),
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
              ),
            ],
          ),
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
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_forward_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
