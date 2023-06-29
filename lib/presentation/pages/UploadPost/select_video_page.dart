// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_storage_path/flutter_storage_path.dart';
// import 'package:flutter/material.dart';
// import '../../../models/video_file_model.dart';

// class SelectVideoPage extends StatefulWidget {
//   static const String routename = '/select-video-page';
//   SelectVideoPage({
//     super.key,
//   });

//   @override
//   _SelectVideoPageState createState() => _SelectVideoPageState();
// }

// class _SelectVideoPageState extends State<SelectVideoPage>
//     with SingleTickerProviderStateMixin {
//   final TransformationController _transformationController =
//       TransformationController();
//   late AnimationController _animationController;

//   List<VideoFileModel>? videoFileFolders;

//   VideoFileModel? selectedVideoFolder;
//   String? video;
//   List<String> selectedFiles = [];

//   bool selectMultipleVideos = false;

//   void toggleSelectMultipleImages() {
//     setState(() {
//       selectMultipleVideos = !selectMultipleVideos;
//       selectedFiles = [];
//     });
//   }

//   bool showGridPaper = false;
//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     super.initState();
//     getImagesPath();
//   }

//   getImagesPath() async {
//     // path to videos folders
//     var videoPath = await StoragePath.videoPath;
//     var videos = jsonDecode(videoPath!) as List;

//     // image-file-folders
//     videoFileFolders =
//         videos.map<VideoFileModel>((e) => VideoFileModel.fromJson(e)).toList();
//     if (videoFileFolders != null && videoFileFolders!.isNotEmpty) {
//       setState(() {
//         selectedVideoFolder = videoFileFolders![0];
//         video = videoFileFolders![0].files[0].path;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('select multiple images is $selectMultipleVideos');
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const <Widget>[
//                   Icon(Icons.clear),
//                   Text(
//                     'Next',
//                     style: TextStyle(color: Colors.blue),
//                   )
//                 ],
//               ),
//             ),
//             Stack(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.45,
//                   width: double.infinity,
//                   child: video != null
//                       ? GestureDetector(
//                           onDoubleTap: () {
//                             _toggleZoom();
//                           },
//                           child: InteractiveViewer(
//                             transformationController: _transformationController,
//                             onInteractionStart: (_) {
//                               setState(() {
//                                 showGridPaper = true;
//                               });
//                             },
//                             onInteractionEnd: (_) {
//                               setState(() {
//                                 showGridPaper = false;
//                               });
//                             },
//                             boundaryMargin: EdgeInsets.all(
//                               showGridPaper ? 100 : 0,
//                             ),
//                             minScale: 0.1,
//                             maxScale: 2.0,
//                             child: GridPaper(
//                               color: showGridPaper
//                                   ? Colors.black
//                                   : Colors.transparent,
//                               divisions: 1,
//                               interval: 1200,
//                               subdivisions: 9,
//                               child: Image.file(
//                                 File(video!),
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.45,
//                                 width: MediaQuery.of(context).size.width,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         )
//                       : Container(),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   DropdownButtonHideUnderline(
//                     child: DropdownButton<VideoFileModel>(
//                       iconEnabledColor: Colors.white,
//                       items: getItems(),
//                       onChanged: (VideoFileModel? d) {
//                         assert(d!.files.isNotEmpty);
//                         video = d!.files[0].path;
//                         setState(() {
//                           selectedVideoFolder = d;
//                         });
//                       },
//                       value: selectedVideoFolder,
//                       dropdownColor: Colors.black,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       selectMultipleVideos
//                           ? IconButton(
//                               onPressed: () {
//                                 toggleSelectMultipleImages();
//                               },
//                               icon: const Icon(Icons.image_aspect_ratio),
//                             )
//                           : IconButton(
//                               onPressed: () {
//                                 toggleSelectMultipleImages();
//                               },
//                               icon: const Icon(
//                                 Icons.hide_image,
//                               ),
//                             ),
//                       const Icon(
//                         Icons.camera_alt,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             selectedVideoFolder == null
//                 ? Container()
//                 : Expanded(
//                     child: GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4,
//                         crossAxisSpacing: 2,
//                         mainAxisSpacing: 2,
//                       ),
//                       itemBuilder: (_, i) {
//                         var file = selectedVideoFolder!.files[i];
//                         print(file);
//                         bool isSelected = selectMultipleVideos
//                             ? selectedFiles.contains(file)
//                             : file == video;
//                         return ImageShowWidget(
//                             file: file.path,
//                             isSelected: isSelected,
//                             onTap: () {
//                               if (isSelected && selectMultipleVideos) {
//                                 print('yeta');
//                                 print(selectedFiles.contains(file));
//                                 setState(() {
//                                   selectedFiles.removeWhere(
//                                       (element) => element == file);
//                                 });
//                               }
//                               if (selectMultipleVideos) {
//                                 setState(() {
//                                   selectedFiles.add(file.path);
//                                 });
//                               } else {
//                                 setState(() {
//                                   video = file.path;
//                                 });
//                               }

//                               print(selectedFiles.length);
//                             });
//                       },
//                       itemCount: selectedVideoFolder!.files.length,
//                     ),
//                   )
//           ],
//         ),
//       ),
//     );
//   }

//   List<DropdownMenuItem<VideoFileModel>> getItems() {
//     if (videoFileFolders != null) {
//       return videoFileFolders!
//           .map((e) => DropdownMenuItem(
//                 value: e,
//                 child: Text(
//                   e.folderName,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ))
//           .toList();
//     } else {
//       return [];
//     }
//   }

//   void _toggleZoom() {
//     if (_transformationController.value.isIdentity()) {
//       _transformationController.value = Matrix4.identity()..scale(2.0);
//     } else {
//       _transformationController.value = Matrix4.identity();
//     }
//   }
// }

// class ImageShowWidget extends StatefulWidget {
//   final String file;
//   final bool isSelected;
//   final Function onTap;
//   const ImageShowWidget(
//       {super.key,
//       required this.file,
//       required this.isSelected,
//       required this.onTap});

//   @override
//   State<ImageShowWidget> createState() => _ImageShowWidgetState();
// }

// class _ImageShowWidgetState extends State<ImageShowWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Stack(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: Image.file(
//               File(widget.file),
//               fit: BoxFit.cover,
//             ),
//           ),
//           if (widget.isSelected)
//             Center(
//               child: Container(
//                 color: Colors.black.withOpacity(0.6),
//               ),
//             ),
//         ],
//       ),
//       onTap: () {
//         widget.onTap();
//       },
//     );
//   }
// }
