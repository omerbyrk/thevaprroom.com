import 'dart:isolate';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../extensions.dart';

import '../globals.dart';

class DownloadProps {
  final String id;
  final DownloadTaskStatus status;
  final int progress;

  DownloadProps(this.id, this.status, this.progress);
}

class DownloadFileManager extends StatefulWidget {
  const DownloadFileManager({
    Key? key,
  }) : super(key: key);

  @override
  State<DownloadFileManager> createState() => _DownloadFileManagerState();
}

class _DownloadFileManagerState extends State<DownloadFileManager> {
  double progress = 0;

  final ReceivePort _port = ReceivePort();
  String taskId = "";

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  void initState() {
    if (IsolateNameServer.lookupPortByName('downloader_send_port') != null) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen((dynamic data) {
      String id = data[0];
      int progress = data[2];
      taskId = id;
      setState(() {
        this.progress = progress / 100;
      });
      debugPrint(this.progress.toString());
    });
    FlutterDownloader.registerCallback(downloadCallback);

    super.initState();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) {
      send.send([id, status.value, progress]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return progress == 0
        ? const SizedBox(
            height: 0,
            width: 0,
          )
        : FloatingActionButton(
            heroTag: "download_manager",
            backgroundColor: Globals.configuration.backgroundColor,
            onPressed: () async {
              if (progress == 1) {
                var result = await FlutterDownloader.open(taskId: taskId);

                if (!result) {
                  // ignore: use_build_context_synchronously
                  final snackbar = SnackBar(
                    content: Text(tr(
                      "download_file_failed_to_open",
                    )),
                  ).toStandart;
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }

                setState(() {
                  progress = 0;
                });
              }
            },
            child: progress < 1
                ? SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      value: progress,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Globals.configuration.primaryColor,
                      ),
                    ),
                  )
                : Icon(
                    Icons.file_open,
                    size: 30,
                    color: Globals.configuration.primaryColor,
                  ),
          );
  }
}
