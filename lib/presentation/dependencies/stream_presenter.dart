import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class StreamPresenter<State> {
  @protected
  final State state;

  StreamPresenter(this.state);

  @protected
  final controller = StreamController<State>.broadcast();

  @protected
  Stream<ReturnType> getStream<ReturnType>(
    ReturnType Function(State) state,
  ) {
    return controller.stream.map(state).distinct();
  }

  @protected
  void update(Function callback) {
    if (!controller.isClosed) {
      callback();
      controller.add(state);
    }
  }
}
