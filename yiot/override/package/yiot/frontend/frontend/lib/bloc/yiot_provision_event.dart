//  ────────────────────────────────────────────────────────────
//                     ╔╗  ╔╗ ╔══╗      ╔════╗
//                     ║╚╗╔╝║ ╚╣╠╝      ║╔╗╔╗║
//                     ╚╗╚╝╔╝  ║║  ╔══╗ ╚╝║║╚╝
//                      ╚╗╔╝   ║║  ║╔╗║   ║║
//                       ║║   ╔╣╠╗ ║╚╝║   ║║
//                       ╚╝   ╚══╝ ╚══╝   ╚╝
//    ╔╗╔═╗                    ╔╗                     ╔╗
//    ║║║╔╝                   ╔╝╚╗                    ║║
//    ║╚╝╝  ╔══╗ ╔══╗ ╔══╗  ╔╗╚╗╔╝  ╔══╗ ╔╗ ╔╗╔╗ ╔══╗ ║║  ╔══╗
//    ║╔╗║  ║║═╣ ║║═╣ ║╔╗║  ╠╣ ║║   ║ ═╣ ╠╣ ║╚╝║ ║╔╗║ ║║  ║║═╣
//    ║║║╚╗ ║║═╣ ║║═╣ ║╚╝║  ║║ ║╚╗  ╠═ ║ ║║ ║║║║ ║╚╝║ ║╚╗ ║║═╣
//    ╚╝╚═╝ ╚══╝ ╚══╝ ║╔═╝  ╚╝ ╚═╝  ╚══╝ ╚╝ ╚╩╩╝ ║╔═╝ ╚═╝ ╚══╝
//                    ║║                         ║║
//                    ╚╝                         ╚╝
//
//    Lead Maintainer: Roman Kutashenko <kutashenko@gmail.com>
//  ────────────────────────────────────────────────────────────

part of 'yiot_provision_bloc.dart';

// -----------------------------------------------------------------------------
abstract class YiotProvisionEvent extends Equatable {
  const YiotProvisionEvent();

  @override
  List<Object> get props => [];
}

// -----------------------------------------------------------------------------
class YiotProvisionStoppedEvent extends YiotProvisionEvent {

  YiotProvisionStoppedEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'YIoT Provision stopped';
}

// -----------------------------------------------------------------------------
class YiotProvisionWaitDeviceEvent extends YiotProvisionEvent {

  YiotProvisionWaitDeviceEvent();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'YIoT Device Wait';
}

// -----------------------------------------------------------------------------
class YiotProvisionDeviceDetectedEvent extends YiotProvisionEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'YIoT Device Detected';
}

// -----------------------------------------------------------------------------
class YiotProvisionInProgressEvent extends YiotProvisionEvent {

  late final stream;

  YiotProvisionInProgressEvent({required this.stream});

  @override
  List<Object> get props => [stream];

  @override
  String toString() => 'YIoT Provision in progress';
}

// -----------------------------------------------------------------------------
class YiotProvisionDoneEvent
    extends YiotProvisionEvent {

  late final license;

  YiotProvisionDoneEvent({required this.license});

  @override
  List<Object> get props => [license];

  @override
  String toString() => 'YIoT Provision done';
}


// -----------------------------------------------------------------------------
class YiotProvisionErrorEvent
    extends YiotProvisionEvent {

  @override
  List<Object> get props => [];

  @override
  String toString() => 'YIoT Provision Error';
}

// -----------------------------------------------------------------------------
