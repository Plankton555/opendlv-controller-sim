function accelerationRequest = GetAccelerationRequest(pos, vel, acc, desiredVelocity)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% simple p-controller
accelerationRequest = (desiredVelocity - vel)/5;


% aiming to reach target speed in some seconds
nrSeconds = 3;
%accelerationRequest = (desiredVelocity - (vel + nrSeconds*acc))/5;


end

