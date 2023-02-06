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

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:yiot_portal/provision/yiot-provision.dart';


part 'yiot_provision_event.dart';
part 'yiot_provision_state.dart';

// -----------------------------------------------------------------------------
class YiotProvisionBloc
    extends Bloc<YiotProvisionEvent, YiotProvisionState> {

  YiotProvisionBloc()
      : super(YiotProvisionStopped()) {

    on<YiotProvisionStoppedEvent>((event, emit) {
      emit(YiotProvisionStopped());
    });

    on<YiotProvisionWaitDeviceEvent>((event, emit) {
      emit(YiotProvisionWaitDevice());
    });

    on<YiotProvisionDeviceDetectedEvent>((event, emit) {
      emit(YiotProvisionDeviceDetected());
    });

    on<YiotProvisionInProgressEvent>((event, emit) {
      emit(YiotProvisionInProgress(stream: event.stream));
    });

    on<YiotProvisionDoneEvent>((event, emit) {
      emit(YiotProvisionDone(license: event.license));
    });

    on<YiotProvisionErrorEvent>((event, emit) {
      emit(YiotProvisionError());
    });
  }

  // ---------------------------------------------------------------------------
  //
  //   Start Device Provision
  //
  void startProvision() async {
    var p = await YIoTProvision.start();
    add(YiotProvisionInProgressEvent(stream: p.stdout));
    p.exitCode.then((res) async {
      if (res == 0) {
        var license = await YIoTProvision.processArtifacts();
        if (license.valid()) {
          // TODO: Save to DB
          add(YiotProvisionDoneEvent(license: license));
        } else {
          add(YiotProvisionErrorEvent());
        }
      } else {
        add(YiotProvisionErrorEvent());
      }
    });
  }

  // ---------------------------------------------------------------------------
  //
  //   Cancel provision attempt
  //
  void cancel() {
    add(YiotProvisionStoppedEvent());
  }

  // ---------------------------------------------------------------------------
  //
  //  Force status request
  //
//  void update() {
//    YIoTJenkinsService.getState(
//        _yiotKeycloakService.token(), _yiotKeycloakService.currentUser())
//        .then((value) {
//      if (value.isEnabled) {
//        add(YiotJenkinsActiveEvent(jenkinsInfo: value));
//      } else {
//        add(YiotJenkinsInactiveEvent());
//      }
//    });
//  }

  // ---------------------------------------------------------------------------
  //
  //   Wait Service Start
  //
//  void _waitStart() {
//    // Emit event of waiting state
//    add(YiotJenkinsWaitActiveEvent());
//
//    // Run Count down timer for a operation processing
//    YIoTCountdown(
//      periodMs: _CHECK_PERIOD,
//      deadlineMs: _OPERATION_DEADLINE,
//
//      // Periodically need to check status
//      onPeriod: (timer, time) {
//        YIoTJenkinsService.getState(_yiotKeycloakService.token(),
//                _yiotKeycloakService.currentUser())
//            .then((value) {
//          if (value.isRunning) {
//            add(YiotJenkinsActiveEvent(jenkinsInfo: value));
//
//            // No need in new timer events
//            timer.cancel();
//          }
//        });
//      },
//
//      // In case of deadline need to set error state
//      onDeadline: () {
//        add(YiotJenkinsErrorEvent(err: YIoTErrorsRest.yiotErrRestTimeout()));
//      },
//    );
//  }

  // ---------------------------------------------------------------------------
  //
  //   Wait Service Stop
  //
//  void _waitStop() {
//    add(YiotJenkinsWaitInactiveEvent());
//
//    // Run Count down timer for a operation processing
//    YIoTCountdown(
//      periodMs: _CHECK_PERIOD,
//      deadlineMs: _OPERATION_DEADLINE,
//
//      // Periodically need to check status
//      onPeriod: (timer, time) {
//        YIoTJenkinsService.getState(_yiotKeycloakService.token(),
//                _yiotKeycloakService.currentUser())
//            .then((value) {
//          if (!value.isRunning) {
//            // Request inactive state
//            add(YiotJenkinsInactiveEvent());
//
//            // No need in new timer events
//            timer.cancel();
//          }
//        });
//      },
//
//      // In case of deadline need to set error state
//      onDeadline: () {
//        add(YiotJenkinsErrorEvent(err: YIoTErrorsRest.yiotErrRestTimeout()));
//      },
//    );
//  }

}

// -----------------------------------------------------------------------------
