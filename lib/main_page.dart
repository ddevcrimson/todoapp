import 'package:flutter/cupertino.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  createState() => _State();
}

class _State extends State<MainPage> {
  var notes = [Note('Title', 'Body')];

  @override
  build(context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text('Welcome'),
      ),
      child: Stack(
        children: [
          Container(color: CupertinoColors.extraLightBackgroundGray),
          CupertinoScrollbar(
            thickness: 0.6,
            thicknessWhileDragging: 10,
            radius: const Radius.circular(34),
            radiusWhileDragging: Radius.zero,
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteWidget(
                  notes[index],
                  () => setState(() => notes.removeAt(index)),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: AddButton(() async {
              var route = CupertinoDialogRoute<Note?>(
                builder: (_) => const AddDialog(),
                context: context,
              );
              var note = await Navigator.push(context, route);
              if (note != null) {
                setState(() => notes.add(note));
              }
            }),
          ),
        ],
      ),
    );
  }
}

class Note {
  String title, content;
  bool done;

  Note(this.title, this.content, [this.done = false]);
}

class NoteWidget extends StatefulWidget {
  final Note note;
  final void Function() onDelete;

  const NoteWidget(this.note, this.onDelete, {super.key});

  @override
  // ignore: no_logic_in_create_state
  createState() => NoteWidgetState(note, onDelete);
}

class NoteWidgetState extends State<NoteWidget> {
  final void Function() onDelete;
  var expanded = false;
  Note note;

  NoteWidgetState(this.note, this.onDelete);

  @override
  build(context) {
    return GestureDetector(
      onLongPress: () async {
        var route = CupertinoDialogRoute<Note?>(
          builder: (_) => AddDialog(source: note),
          context: context,
        );
        var newNote = await Navigator.push(context, route);
        if (newNote != null) {
          setState(() => note = newNote);
        }
      },
      onTap: () => setState(() => expanded = !expanded),
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border.all(color: CupertinoColors.opaqueSeparator),
        ),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment:
              note.done ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      decoration: note.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (!note.done)
                    Text(
                      expanded
                          ? note.content
                          : note.content.replaceAll('\n\t\r', ' '),
                      overflow: TextOverflow.ellipsis,
                      maxLines: expanded ? 999 : null,
                    ),
                ],
              ),
            ),
            Row(
              children: [
                CupertinoButton(
                  onPressed: () => setState(() {
                    note.done = !note.done;
                  }),
                  child: Icon(
                    CupertinoIcons.check_mark,
                    color: note.done ? CupertinoColors.opaqueSeparator : null,
                  ),
                ),
                CupertinoButton(
                  onPressed: onDelete,
                  child: const Icon(CupertinoIcons.delete_solid),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  final void Function() onClick;

  const AddButton(this.onClick, {super.key});

  @override
  // ignore: no_logic_in_create_state
  createState() => AddButtonState(onClick);
}

class AddButtonState extends State<AddButton> {
  final void Function() onClick;
  Color color = CupertinoColors.systemBlue;
  Color defaultColor = CupertinoColors.systemBlue;
  Color tappedColor = const Color.fromARGB(255, 153, 202, 255);

  AddButtonState(this.onClick);

  @override
  build(context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => color = tappedColor),
      onTapUp: (_) {
        setState(() => color = defaultColor);
        onClick();
      },
      onTapCancel: () => setState(() => color = defaultColor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 10),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Icon(
            CupertinoIcons.add,
            size: 50,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }
}

class AddDialog extends StatefulWidget {
  final Note? source;

  const AddDialog({this.source, super.key});

  @override
  // ignore: no_logic_in_create_state
  createState() => AddDialogState(source);
}

class AddDialogState extends State<AddDialog> {
  Color? colorTitle, colorContent;
  var shakeTitle = false, shakeContent = false;
  var titleText = "", contentText = "";

  AddDialogState([Note? source]) {
    if (source != null) {
      titleText = source.title;
      contentText = source.content;
    }
  }

  @override
  build(context) {
    return CupertinoAlertDialog(
      title: const Text('Create new task'),
      content: Column(
        children: [
          const Text('Do you accept?'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ShakeWidget(
              enableWebMouseHover: false,
              autoPlay: shakeTitle,
              shakeConstant: ShakeDefaultConstant1(),
              child: CupertinoTextField(
                controller: TextEditingController(text: titleText),
                placeholderStyle: colorTitle != null
                    ? TextStyle(color: colorTitle)
                    : const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: CupertinoColors.placeholderText),
                placeholder: 'Title',
                autofocus: true,
                onChanged: (text) {
                  if (colorTitle != null || colorContent != null) {
                    setState(() {
                      colorTitle = null;
                      colorContent = null;
                    });
                  }
                  titleText = text;
                },
              ),
            ),
          ),
          ShakeWidget(
            enableWebMouseHover: false,
            autoPlay: shakeContent,
            shakeConstant: ShakeDefaultConstant1(),
            child: CupertinoTextField(
              controller: TextEditingController(text: contentText),
              placeholderStyle: colorContent != null
                  ? TextStyle(color: colorContent)
                  : const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: CupertinoColors.placeholderText),
              placeholder: 'Content',
              onChanged: (text) {
                if (colorTitle != null || colorContent != null) {
                  setState(() {
                    colorTitle = null;
                    colorContent = null;
                  });
                }
                contentText = text;
              },
              minLines: 5,
              maxLines: 5,
            ),
          ),
        ],
      ),
      actions: [
        CupertinoButton(
          child: const Text('Accept'),
          onPressed: () {
            if (titleText.isNotEmpty && contentText.isNotEmpty) {
              return Navigator.pop(context, Note(titleText, contentText));
            }
            setState(() {
              if (titleText.isEmpty) {
                shakeTitle = true;
                colorTitle = CupertinoColors.systemRed;
              }
              if (contentText.isEmpty) {
                shakeContent = true;
                colorContent = CupertinoColors.systemRed;
              }
            });
            Future.delayed(const Duration(milliseconds: 250))
                .then((value) => setState(() {
                      shakeTitle = false;
                      shakeContent = false;
                    }));
          },
        ),
        CupertinoButton(
          child: const Text('Decline'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
