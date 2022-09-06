import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:moivoice/posts.dart';
import 'text_page.dart';
import 'img_video_select.dart';
import 'admin_private_page.dart';


String? viewOrder = 'latest';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the AdminHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 30,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              color: Colors.green,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AdminHomePage(title: 'MoiVoice-Admin View');
                }));
              },
            ),
            DropdownButton<String>(
              value: viewOrder,
              icon: const Icon(Icons.arrow_downward_outlined),
              onChanged: (String? newValue) {
                setState(() {
                  viewOrder = newValue;
                });
              },
              items: <String>['latest', 'trending']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'profile',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ProfilePage(title: 'MoiVoice-Admin View');
                }));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[Posts()],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: ExpandableFab(
          distance: 112.0,
          children: [
            ActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TextPage(title: 'MoiVoice');
                }));
              },
              icon: const Icon(Icons.format_size),
            ),
            ActionButton(
              onPressed: () async {
                try {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.any,
                    allowCompression: false,
                  );
                  if (result != null) {
                    io.File pickedGalleryFile =
                        io.File(result.files.single.path!);

                    if (pickedGalleryFile.path.contains("png") ||
                        pickedGalleryFile.path.contains("jpg")) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ImgVidSelectPage(
                            title: 'MoiVoce',
                            imgVid: pickedGalleryFile,
                            imgVidType: 'image');
                      }));
                    }
                  }
                } catch (error) {
                  print("error: $error");
                }
              },
              icon: const Icon(Icons.insert_photo),
            ),
            ActionButton(
              onPressed: () {},
              icon: const Icon(Icons.photo_camera),
            ),
          ],
        )
        // This trailing comma makesUndefined class 'File'. auto-formatting nicer for build methods.
        );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
          child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 4.0,
        child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            )),
      )),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);

    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.223, 1, curve: Curves.easeOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.secondary,
      ),
    );
  }
}
