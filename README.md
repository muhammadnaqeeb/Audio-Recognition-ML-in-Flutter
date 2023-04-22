# Audio Recognition using Tensorflow Lite in Flutter Applications

### Integrating the model into application
To integrate tensorflow models in mobile applications, the Tensorflow Lite framework helps to run these models on mobile. 

First, add the following dependency on your pubspec.yaml file:
```
dependencies:
	tflite_audio: ^0.3.0
```

Create a new /assets directory, add the **soundclassifier.tflite** and **labels.txt** files 

```
flutter:
  # To add assets to your application, add an assets section:
  assets:
    - assets/labels.txt
    - assets/soundclassifier.tflite
```


Android configurations (See documentation for configuration)
```
1.Add the following permissions to AndroidManifest.xml:
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

2. Add aaptOptions to app/build.gradle file:
android {
   (...)
    aaptOptions {
        noCompress 'tflite'
    }    lintOptions {
        disable 'InvalidPackage'
    }
(...)
}

3. Enable select-ops in app/build.gradle file:
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation "org.tensorflow:tensorflow-lite-select-tf-ops:+"
}

4. Change the minSdkVersion to at least 24 in app/build.gradle file.
```

### Load and use the model
On your initState() method, you must load the model:
```
TfliteAudio.loadModel(
    model: 'assets/soundclassifier.tflite',
    label: 'assets/labels.txt',
    numThreads: 1,
    inputType: 'rawAudio',
    isAsset: true);

```

As the classification model is a **GTM model**, you must specify the **inputType** of audio recognition as **‘rawAudio’**. If you are using your **own model** (a decodedwav model) instead of GTM model, the inputType must be **‘decodedWav’**. For **sampleRate**, the recommended values on package documentation are **16000**, **22050** or **44100**, and it will be used the higher one to improve the accuracy. The recordingLength value must be equal to tensor input and bufferSize should be half the value of recordingLenght.
```
Stream<Map<dynamic, dynamic>> ?result;
```

```
void _recorder() {
    String recognition = "";
    if (!_recording) {
      setState(() => _recording = true);
      result = TfliteAudio.startAudioRecognition(
        numOfInferences: 1,
        //inputType: 'rawAudio',
        sampleRate: 44100,
        //recordingLength: 44032, // name changes see Doc.
        bufferSize: 22016,
      );
      result.listen((event) {
        recognition = event["recognitionResult"];
      }).onDone(() {
        setState(() {
          _recording = false;
          _sound = recognition.split(" ")[1];
        });
      });
   }
  } 

```






