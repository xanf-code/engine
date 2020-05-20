// Copyright 2020 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

import 'scenario.dart';

/// Sends the recieved locale data back as semantics information.
class LocaleInitialization extends Scenario {
  /// Constructor
  LocaleInitialization(Window window)
      : assert(window != null),
        super(window);

  int tapCount = 0;

  @override
  void onBeginFrame(Duration duration) {
    // Doesn't matter what we draw. Just paint white.
    final SceneBuilder builder = SceneBuilder();
    final PictureRecorder recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, window.physicalSize.width, window.physicalSize.height),
      Paint()..color = const Color.fromARGB(255, 255, 255, 255),
    );
    final Picture picture = recorder.endRecording();

    builder.addPicture(
      Offset.zero,
      picture,
    );
    final Scene scene = builder.build();
    window.render(scene);
    scene.dispose();

    // On the first frame, pretend that it drew a text field. Send the
    // corresponding semantics tree comprised of 1 node with the locale data
    // as the label.
    window.updateSemantics((SemanticsUpdateBuilder()
      ..updateNode(
        id: 0,
        // SemanticsFlag.isTextField.
        flags: 16,
        // SemanticsAction.tap.
        actions: 1,
        rect: const Rect.fromLTRB(0.0, 0.0, 414.0, 48.0),
        label: window.locales.toString(),
        textDirection: TextDirection.ltr,
        textSelectionBase: -1,
        textSelectionExtent: -1,
        platformViewId: -1,
        maxValueLength: -1,
        currentValueLength: 0,
        scrollChildren: 0,
        scrollIndex: 0,
        transform: Matrix4.identity().storage,
        elevation: 0.0,
        thickness: 0.0,
        childrenInTraversalOrder: Int32List(0),
        childrenInHitTestOrder: Int32List(0),
        additionalActions: Int32List(0),
      )).build()
    );
  }

  // We don't really care about the touch itself. It's just a way for the
  // XCUITest to communicate timing to the mock framework.
  @override
  void onPointerDataPacket(PointerDataPacket packet) {
    String label;
    switch(tapCount) {
      case 0: label = window.platformResolvedLocale.toString(); break;
      // Expand for other test cases.
    }

    window.updateSemantics((SemanticsUpdateBuilder()
      ..updateNode(
        id: 0,
        // SemanticsFlag.isTextField and SemanticsFlag.isFocused.
        flags: 48,
        actions: 18433,
        rect: const Rect.fromLTRB(0.0, 0.0, 414.0, 48.0),
        label: label,
        textDirection: TextDirection.ltr,
        textSelectionBase: 0,
        textSelectionExtent: 0,
        platformViewId: -1,
        maxValueLength: -1,
        currentValueLength: 0,
        scrollChildren: 0,
        scrollIndex: 0,
        transform: Matrix4.identity().storage,
        elevation: 0.0,
        thickness: 0.0,
        childrenInTraversalOrder: Int32List(0),
        childrenInHitTestOrder: Int32List(0),
        additionalActions: Int32List(0),
      )).build()
    );
    tapCount++;
  }
}
