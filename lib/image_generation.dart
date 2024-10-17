import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

class AiImageGeneration extends StatefulWidget {
  const AiImageGeneration({super.key});

  @override
  State<AiImageGeneration> createState() => _AiImageGenerationState();
}

class _AiImageGenerationState extends State<AiImageGeneration> {
  /// The text editing controller for the query.
  final TextEditingController _queryController = TextEditingController();

  /// Initializes the [StabilityAI] class from the 'brain_fusion' package.
  final StabilityAI _ai = StabilityAI();

  /// This is the api key from stability.ai or https://dreamstudio.ai/, Create yours and replace it here.
  final String apiKey = 'sk-Y9emKXysGDjToLX91fOlj9jbbatyu0eac1ucNDsaw51IJgud';

  /// This is the style [ImageAIStyle]
  final ImageAIStyle imageAIStyle = ImageAIStyle.digitalPainting;

  /// The boolean value to run the function.
  bool run = false;

  /// The [_generate] function to generate image data.
  Future<Uint8List> _generate(String query) async {
    /// Call the generateImage method with the required parameters.
    Uint8List image = await _ai.generateImage(
      apiKey: apiKey,
      imageAIStyle: imageAIStyle,
      prompt: query,
    );
    return image;
  }

  @override
  void dispose() {
    /// Dispose the [_queryController].
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// The size of the container for the generated image.
    final double size = Platform.isAndroid || Platform.isIOS
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height / 2;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('TEXT TO IMAGE'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  controller: _queryController,
                  decoration: InputDecoration(
                    hintText: 'Enter query text...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 8),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  // height: size,
                  // width: size,
                  child: run
                      ? FutureBuilder<Uint8List>(
                          /// Call the [_generate] function to get the image data.
                          future: _generate(_queryController.text),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              /// While waiting for the image data, display a loading indicator.
                              return Center(
                                child: const CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              /// If an error occurred while getting the image data, display an error message.
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              /// If the image data is available, display the image using Image.memory().
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(snapshot.data!),
                              );
                            } else {
                              /// If no data is available, display a placeholder or an empty container.
                              return Container();
                            }
                          },
                        )
                      : const Center(
                          child: Text(
                            'Enter Text and Click the button to generate',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),
              ),
              TextButton(
                onPressed: () {
                  /// Get the user input from the [_queryController].
                  String query = _queryController.text;
                  if (query.isNotEmpty) {
                    /// If the user input is not empty, set [run] to true to generate the image.
                    setState(() {
                      run = true;
                    });
                  } else {
                    /// If the user input is empty, print an error message.
                    if (kDebugMode) {
                      print('Query is empty !!');
                    }
                  }
                },
                child: Text(
                  'Generate Image',
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.amber,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
