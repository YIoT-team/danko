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
abstract class YiotProvisionState extends Equatable {
  const YiotProvisionState();
}

// -----------------------------------------------------------------------------
class YiotProvisionStopped extends YiotProvisionState {
  @override
  List<Object> get props => [];
}

// -----------------------------------------------------------------------------
class YiotProvisionWaitDevice extends YiotProvisionState {
  @override
  List<Object> get props => [];
}

// -----------------------------------------------------------------------------
class YiotProvisionDeviceDetected extends YiotProvisionState {
  @override
  List<Object> get props => [];
}

// -----------------------------------------------------------------------------
class YiotProvisionInProgress extends YiotProvisionState {
  late final stream;

  YiotProvisionInProgress({required this.stream});

  @override
  List<Object> get props => [stream];
}

// -----------------------------------------------------------------------------
class YiotProvisionDone extends YiotProvisionState {

  late final license;

  YiotProvisionDone({required this.license});

  @override
  List<Object> get props => [license];
}

// -----------------------------------------------------------------------------
class YiotProvisionError extends YiotProvisionState {
  @override
  List<Object> get props => [];
}

// -----------------------------------------------------------------------------
