# Draggable Resizer

Allows to seemlessly drag the widget in two (2) dimensional axis, along with resizing and rotating it the same time.

## Features

- Seamlessly drag the widget
- Allows resizing while dragging
- Allows rotating while dragging

## Usage

### Step1: Adding plugin dependency
- add the plugin to your pubspec.yaml file:

```yaml
draggable_resizer: [latest_version]
```

### Step2: Importing the package.
- import the plugin in [your_file].dart

```dart
import 'package:draggable_resizer/draggable_resizer.dart';
```

### Step3: Call the draggable 
- Drag it horizontally from left to right direction 

```dart
const DraggableResizer(
        draggerColor: Colors.white,
        axis: Axis.horizontal,
        direction: Direction.leftToRight)
```

### Step4: Listen to state changes  
- you can also listen to value changes from 1 to 100 (Left to Right):

```dart
const DraggableResizer(
        draggerColor: Colors.white,
        axis: Axis.horizontal,
        direction: Direction.leftToRight,
        onValueChange: ((val) => setState(() {
            print("Value changed to $val");
        })))
```


### Step5: Change widgets to your own customize widgets 
-  Go to example/lib/main.dart file to see all examples
-  See next section for images

### Step6: Run!
- Use this command in terminal: "flutter run"



### Examples:

Initially it was made as an alternative for 'resizing sliders' but later on found several use cases as listed below:




## Important URL

- [PUBDEV URL](https://pub.dev/packages/draggable_resizer)

- [GITHUB URL](https://github.com/JaveriaJR/draggable_resizer/tree/main/example)



## FAQ

In case you need: to add new feature or you get any error or any help, please contact me at javeriaiffat312@gmail.com or javeria.iffat@lums.edu.pk
please be kind if you get any errors, text me I'll be more than happy to help you all.

THANK YOU!

