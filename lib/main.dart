import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:image_generations_with_midjourney_api/resources/hard_coded_content.dart';
import 'package:image_generations_with_midjourney_api/resources/image_generation_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GenerateImage(),
    );
  }
}

class GenerateImage extends StatefulWidget {
  const GenerateImage({super.key});

  @override
  State<GenerateImage> createState() => _GenerateImageState();
}

class _GenerateImageState extends State<GenerateImage> {
  TextEditingController promptController = TextEditingController();
  TextEditingController negativePromptController = TextEditingController();
  int totalLengthPrompt = 200;
  int presentLenghtPrompt = 0;
  int totalLengthNPrompt = 150;
  int presentLenghtNPrompt = 0;
  int selectedArtStyle = 0;
  int selectedAspectRatio = 0;
  bool isGenerating = false;
  bool isImageUploadedToCloudinary = false;
  Uint8List? generatedImageUrl;
  bool showGeneratedBtn = false;
  final ScrollController _scrollController = ScrollController();
  final imageGenerationController = Get.put(ImageGenerationController());

  String getAspectRatio(int index) {
    return Content.aspectRatios[index];
  }

  int getArtStylesId(int index) {
    return Content.artStylesId[index];
  }

  generateAiImage() async {
    try {
      if (promptController.text.isNotEmpty &&
          negativePromptController.text.isNotEmpty) {
        setState(() {
          isGenerating = true;
        });
        int styleId = getArtStylesId(selectedArtStyle);
        String aspectRatio = getAspectRatio(selectedAspectRatio);
        generatedImageUrl = await imageGenerationController.generateImage(
          promptController.text,
          negativePromptController.text,
          aspectRatio,
          styleId,
          context,
        );
        setState(() {
          isGenerating = false;
        });
      } else {
        debugPrint("Plz enter data of both prompt and negative prompt");
      }
    } catch (e) {
      debugPrint("Error : generateImage() > $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent / 2) {
      if (!showGeneratedBtn) {
        setState(() {
          showGeneratedBtn = true;
        });
      }
    } else {
      if (showGeneratedBtn) {
        setState(() {
          showGeneratedBtn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListView(
                controller: _scrollController,
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  // app name with logo
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Generate AI Images - Midjourney AI Model API",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // hey user name
                  Text(
                    "Hey!",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // taking prompt field
                  promptTextFields(
                    hintText: "Enter prompt to generate image",
                    controller: promptController,
                    totalLength: totalLengthPrompt,
                    fieldLength: 3,
                    promptValue: "+ve",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // taking negative prompt field
                  promptTextFields(
                    hintText: "Enter here negative prompt",
                    controller: negativePromptController,
                    totalLength: totalLengthNPrompt,
                    fieldLength: 1,
                    promptValue: "-ve",
                  ),
                  // art style selection
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Art Styles",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Select your favourite art style, that's image will generate",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        Content.artStylesText.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedArtStyle = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                left: 2,
                                right: 6,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selectedArtStyle == index
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(-1, -1),
                                    blurRadius: 3,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 130,
                                    height: 150,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.asset(
                                        Content.artStylesImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    Content.artStylesText[index],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // aspect ration selection
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Aspect Ratio",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Select aspect ration frame that impact the height and width of image",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(3, 3),
                          blurRadius: 3,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        BoxShadow(
                          offset: const Offset(-3, -3),
                          blurRadius: 3,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 30,
                        mainAxisExtent: 40,
                      ),
                      itemCount: 6,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAspectRatio = index;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectedAspectRatio == index
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              Content.aspectRatios[index],
                              style: TextStyle(
                                fontSize: 15,
                                color: selectedAspectRatio == index
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: double.infinity,
                    height: generatedImageUrl != null ? 300 : 250,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [6, 2],
                      child: isGenerating
                          ? Center(
                              child: Lottie.asset(
                                "assets/animations/image_construction.json",
                                fit: BoxFit.cover,
                                reverse: true,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: generatedImageUrl != null
                                    ? Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Image.memory(
                                              generatedImageUrl!,
                                              fit: BoxFit.fitHeight,
                                              width: double.infinity,
                                              height: 300,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "Generated Image will be shown here",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: showGeneratedBtn ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(14).copyWith(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 3,
                        shadowColor: Colors.blue,
                      ),
                      onPressed: () async {
                        await generateAiImage();
                      },
                      child: isGenerating
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(
                              "Generate Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget promptTextFields(
      {String? hintText,
      TextEditingController? controller,
      int? totalLength,
      int? fieldLength,
      String? promptValue}) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.only(
        top: 8,
        left: 18,
        right: 18,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            blurRadius: 3,
            color: Colors.grey.withOpacity(0.2),
          ),
          BoxShadow(
            offset: const Offset(-2, -2),
            blurRadius: 3,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            cursorColor: Colors.grey,
            maxLines: fieldLength ?? 4,
            decoration: InputDecoration(
              hintText: hintText ?? "Type here prompt",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(totalLength),
            ],
            onChanged: (String val) {
              if (val.length <= totalLength!) {
                if (promptValue == "+ve") {
                  setState(() {
                    presentLenghtPrompt = val.length;
                  });
                } else if (promptValue == "-ve") {
                  setState(() {
                    presentLenghtNPrompt = val.length;
                  });
                }
              }
            },
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  controller!.clear();
                  setState(() {
                    if (promptValue == "+ve") {
                      presentLenghtPrompt = 0;
                    } else if (promptValue == "-ve") {
                      presentLenghtNPrompt = 0;
                    }
                  });
                },
                child: const Icon(
                  Icons.rotate_left_sharp,
                  size: 23,
                  color: Colors.blue,
                ),
              ),
              Text(
                "${promptValue == "+ve" ? presentLenghtPrompt : presentLenghtNPrompt}/$totalLength",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
