clear all;
tof = adi.AD96TOF1EBZ();
tof.IPAddress = '192.168.86.53';

% depthMap = tof();
% imshow(depthMap);
figure(1);tof.imshow();
tof.FrameType = 'Ir';
tof.CameraMode = 'Medium';
figure(2);tof.imshow();

clear tof;
