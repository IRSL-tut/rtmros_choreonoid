for TASK in O1 O2 R11L R11M R12 R2AB R2C R3A R3B R4 R5; do

CNOID_FILE=${TASK}.cnoid
\cp -f $(rospack find jvrc_models)/model/tasks/${TASK}/${TASK}.cnoid ${CNOID_FILE}

VIEWPOS=$(grep -n '^views:' ${CNOID_FILE} | sed -e 's@\([0-9]\+\).*@\1@')

sed -i -e "s@modelFile: \"@modelFile: \"tasks/${TASK}/@" ${CNOID_FILE}
sed -i -e "1,${VIEWPOS}s@id: 2@id: 2\n          name: \"JAXON_JVRC\"\n          plugin: Body\n          class: BodyItem\n          data: \n            modelFile: \"JAXON_JVRC/JAXON_JVRCmain_hrpsys_bush.wrl\"\n            currentBaseLink: \"WAIST\"\n            rootPosition: [ 3.2, 2.5, 1.332 ]\n            rootAttitude: [ \n              0, -1, 0, \n              1, 0, 0, \n              0, 0, 1 ]\n            jointPositions: [ \n               0.000054, -0.003093, -0.262419,  0.681091, -0.418672,  0.003093,  0.000054, -0.003093, -0.262401,  0.681084, \n              -0.418684,  0.003093,  0.000000,  0.000000,  0.000000,  0.000000,  0.000000,  0.000000,  0.523599, -0.349066, \n              -0.087266, -1.396263,  0.000000,  0.000000, -0.349066,  0.000000,  0.523599,  0.349066,  0.087266, -1.396263, \n               0.000000,  0.000000, -0.349066,  0.000000,  0.000000,  0.000000,  0.000000,  0.000000 ]\n            initialRootPosition: [ 3.2, 2.5, 1.332 ]\n            initialRootAttitude: [ \n              0, -1, 0, \n              1, 0, 0, \n              0, 0, 1 ]\n            initialJointPositions: [ \n               0.000054, -0.003093, -0.262419,  0.681091, -0.418672,  0.003093,  0.000054, -0.003093, -0.262401,  0.681084, \n              -0.418684,  0.003093,  0.000000,  0.000000,  0.000000,  0.000000,  0.000000,  0.000000,  0.523599, -0.349066, \n              -0.087266, -1.396263,  0.000000,  0.000000, -0.349066,  0.000000,  0.523599,  0.349066,  0.087266, -1.396263, \n               0.000000,  0.000000, -0.349066,  0.000000,  0.000000,  0.000000,  0.000000,  0.000000,  0.000000 ]\n            zmp: [ 0, 0, 0 ]\n            collisionDetection: true\n            selfCollisionDetection: false\n            isEditable: true\n          children: \n            - \n              id: 3\n              name: \"BodyRTC\"\n              plugin: OpenRTM\n              class: BodyRTCItem\n              data: \n                isImmediateMode: true\n                moduleName: \"/home/player/ros/indigo/src/rtm-ros-robotics/rtmros_choreonoid/hrpsys_choreonoid/PDcontroller.so\"\n                confFileName: \"/home/player/ros/indigo/src/rtm-ros-robotics/rtmros_choreonoid/hrpsys_ros_bridge_jvrc/config/SensorReaderRTC.PD.conf\"\n                configurationMode: Use Configuration File\n                AutoConnect: false\n                InstanceName: JAXON_JVRC\n                bodyPeriodicRate: 0.002\n        - \n          id: 100@" ${CNOID_FILE}

if [ "$(grep recordFile: ${CNOID_FILE} | wc -l)" != "0" ]; then
sed -i -e "s@\(recordFile:.*\)@\1\n            - \n              id: 5\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ HEAD_LEFT_CAMERA ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 6\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ CHEST_CAMERA ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 7\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ HEAD_RANGE ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 8\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ LARM_CAMERA ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 9\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ RARM_CAMERA ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 22\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ LARM_CAMERA_N ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 22\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ RARM_CAMERA_N ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n        - \n          id: 10\n          name: \"roslaunch\"\n          plugin: Base\n          class: ExtCommandItem\n          data: \n            command: /home/player/roslaunch.sh\n            executeOnLoading: true\n@" ${CNOID_FILE}
else
sed -i -e "s@\(info:.*\)@\1\n            - \n              id: 5\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ HEAD_LEFT_CAMERA ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 6\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ CHEST_CAMERA ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 7\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ HEAD_RANGE ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 8\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ LARM_CAMERA ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 9\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ RARM_CAMERA ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 22\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ LARM_CAMERA_N ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n            - \n              id: 22\n              name: \"GLVisionSimulator\"\n              plugin: Body\n              class: GLVisionSimulatorItem\n              data: \n                enabled: true\n                targetBodies: [ JAXON_JVRC ]\n                targetSensors: [ RARM_CAMERA_N ]\n                maxFrameRate: 1000\n                maxLatency: 1\n                recordVisionData: false\n                useThread: true\n                useThreadsForSensors: true\n                bestEffort: false\n                allSceneObjects: false\n                rangeSensorPrecisionRatio: 2\n                depthError: 0\n                enableHeadLight: true\n                enableAdditionalLights: true\n        - \n          id: 10\n          name: \"roslaunch\"\n          plugin: Base\n          class: ExtCommandItem\n          data: \n            command: /home/player/roslaunch.sh\n            executeOnLoading: true\n@" ${CNOID_FILE}
fi

sed -i -e "s@info: \"@info: \"tasks/${TASK}/@" ${CNOID_FILE}

IDPOS=$(grep -n ' id:' ${CNOID_FILE} | sed -e 's@\([0-9]\+\).*@\1@')
VIEWPOS=$(grep -n '^views:' ${CNOID_FILE} | sed -e 's@\([0-9]\+\).*@\1@')

poslst=""
idcntr=0
for pos in ${IDPOS}; do
    #echo "${pos} ${VIEWPOS}"
    if [ ${pos} -le ${VIEWPOS} ]; then
        sed -i -e "${pos},${pos}s@id: \([0-9]\+\)@id: ${idcntr}@" ${CNOID_FILE}
        poslst="${poslst}${idcntr}, "
        idcntr=$(expr ${idcntr} + 1)
    fi
done

echo ${poslst}
sed -i -e "s@checked: .*@checked: [ ${poslst} ]@" ${CNOID_FILE}

WSPOS=$(grep -n 'WAIST' ${CNOID_FILE} | sed -e 's@\([0-9]\+\).*@\1@')
WEPOS=$(expr ${WSPOS} + 22)

case "$TASK" in
"O1"   ) RPOS="3.2, 3.0, 1.332" ;;
"O2"   ) RPOS="2.9, 2.8, 4.632" ;;
"R11L" ) RPOS="3.2, 2.5, 1.332" ;;
"R11M" ) RPOS="3.2, 2.5, 1.332" ;;
"R12"  ) RPOS="3.2, 2.5, 1.332" ;;
"R2AB" ) RPOS="4.5, 2.7, 1.332" ;;
"R2C"  ) RPOS="6.8, 2.3, 1.332" ;;
"R3A"  ) RPOS="3.2, 2.5, 1.332" ;;
"R3B"  ) RPOS="3.2, 2.5, 1.332" ;;
"R4"   ) RPOS="4.6, 2.7, 1.332" ;;
"R5"   ) RPOS="3.2, 3.1, 1.332" ;;
esac

sed -i -e "${WSPOS},${WEPOS}s@rootPosition:.*]@rootPosition: [ ${RPOS} ]@" ${CNOID_FILE}
sed -i -e "${WSPOS},${WEPOS}s@initialRootPosition:.*]@initialRootPosition: [ ${RPOS} ]@" ${CNOID_FILE}
done ####

# O1.cnoid-            rootPosition: [ 3.2, 3.0, 1.332 ]
# O2.cnoid-            rootPosition: [ 2.9, 2.8, 4.632 ]
# R11L.cnoid-            rootPosition: [ 3.2, 2.5, 1.332 ]
# R11M.cnoid-            rootPosition: [ 3.2, 2.5, 1.332 ]
# R12.cnoid-            rootPosition: [ 3.2, 2.5, 1.332 ]
# R2AB.cnoid-            rootPosition: [ 4.5, 2.7, 1.332 ]
# R2C.cnoid-            rootPosition: [ 6.8, 2.3, 1.332 ]
# R3A.cnoid-            rootPosition: [ 3.2, 2.5, 1.332 ]
# R3B.cnoid-            rootPosition: [ 3.2, 2.5, 1.332 ]
# R4.cnoid-            rootPosition: [ 4.6, 2.7, 1.332 ]
# R5.cnoid-            rootPosition: [ 3.2, 3.1, 1.332 ]
