import 'package:flutter/material.dart';
import 'package:tflite_audio/tflite_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _sound = "Press the button to start";
  bool _recording = false;
  Stream<Map<dynamic, dynamic>>? result;

  @override
  void initState() {
    TfliteAudio.loadModel(
        model: "assets/soundclassifier.tflite",
        label: "assets/labels.txt",
        // for Google's Teachable Machine models
        inputType: 'rawAudio',
        //  for decodedWav models use
        //  inputType: 'decodedWav'
        numThreads: 1,
        isAsset: true);
    super.initState();
  }

  void _recorder() {
    String recognition = "";
    if (!_recording) {
      setState(() {
        _recording = true;
      });
      result = TfliteAudio.startAudioRecognition(
        sampleRate: 44100,
        bufferSize: 22016,
        numOfInferences: 5,
        detectionThreshold: 0.3,
      );
      result?.listen((event) {
        recognition = event["recognitionResult"];
      }).onDone(() {
        setState(() {
          _recording = false;
          _sound = recognition.split(" ")[1];
        });
      });
    }
  }

  void _stop() {
    TfliteAudio.stopAudioRecognition();
    setState(() => _recording = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "What's this sound?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w200,
                ),
              ),
              MaterialButton(
                onPressed: _recorder,
                color: _recording ? Colors.grey : Colors.pink,
                textColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(25),
                child: const Icon(Icons.mic, size: 60),
              ),
              Text(
                _sound,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
