import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:helder_proto/utils/constants/colors.dart';

class HelderToggleSwitch extends StatefulWidget {
  final ValueChanged<bool> onToggle;
  final bool initialValue;
  
  const HelderToggleSwitch({
    super.key,

    required this.onToggle,
    this.initialValue = false
  });

  @override
  State<HelderToggleSwitch> createState() => _HelderToggleSwitchState();
}

class _HelderToggleSwitchState extends State<HelderToggleSwitch> {
  late bool firstSwitchValue;

  @override
  void initState() {
    super.initState();
    
    firstSwitchValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<bool>.size(
      current: firstSwitchValue,
      values: const [false, true],
      iconOpacity: 1.0,
      indicatorSize: const Size.fromWidth(135),
      customIconBuilder: (context, local, global) {
        return Text(
          local.value ?  "betaald" : "nog betalen",
          style: TextStyle(
            color: Color.lerp(HelderColors.darkGrey, HelderColors.white, local.animationValue),
            fontFamily: 'Rota',
            fontWeight: FontWeight.w800,
            fontSize: 18
          ) 
          
        );
      },
      borderWidth: 0,
      iconAnimationType: AnimationType.onHover,
      style: ToggleStyle(
        backgroundColor: HelderColors.lightGrey,
        indicatorColor: HelderColors.purple,
        boxShadow: [
          BoxShadow(
            color: HelderColors.darkGrey.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ]
      ),
      selectedIconScale: 1.0,
      onChanged: (value) { 
        setState(() => firstSwitchValue = value);
        
        widget.onToggle(value); 
      },
    );

  }
}