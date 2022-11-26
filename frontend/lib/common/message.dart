import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

enum MessageType {
  Success,
  Info,
  Error,
}

class Message {
  Message({
    required this.context,
    required this.message,
    this.messageType = MessageType.Success,
  });

  final BuildContext context;
  final String message;
  final MessageType messageType;

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
      build(),
    );
  }

  SnackBar build() {
    return SnackBar(
      margin: context.breakpoint > LayoutBreakpoint.sm
          ? EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 4,
              5.0,
              MediaQuery.of(context).size.width / 4,
              10.0,
            )
          : null,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              color: messageType == MessageType.Info
                  ? Theme.of(context).colorScheme.onTertiaryContainer
                  : messageType == MessageType.Success
                      ? Theme.of(context).colorScheme.onSecondaryContainer
                      : Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
      backgroundColor: messageType == MessageType.Info
          ? Theme.of(context).colorScheme.tertiaryContainer
          : messageType == MessageType.Success
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.errorContainer,
      behavior: context.breakpoint > LayoutBreakpoint.sm
          ? SnackBarBehavior.floating
          : SnackBarBehavior.fixed,
    );
  }
}
