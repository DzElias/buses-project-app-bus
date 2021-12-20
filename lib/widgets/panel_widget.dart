import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'bus-route.dart';

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  final PanelController panelController;
  final Widget panelContent;
  
  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
    required this.panelContent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        controller: controller,
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 12),
          buildDragHandle(),
          busRoutes(),
        ],
      );

  busRoutes() {
    return panelContent;
  }

  buildDragHandle() => GestureDetector(
    
    child: Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(12)),
          ),
        ),
    onTap: togglePanel
  );

  void togglePanel() => panelController.isPanelOpen
   ? panelController.close() : panelController.open();
}
