%close all; clear all;
%%

deltaTime = 0.1; % size of time steps
nrIterations = 500;

desiredSpeed = 25;
initialSpeed = 0;

currentSpeed = initialSpeed;

accDelta = 2*deltaTime; % max possible acceleration change per second (2 m/s^3??? Is this the jerk?)

maxAcceleration = 4; % 4 m/s^2
maxDeceleration = 7; % -7 m/s^2



State = zeros(nrIterations, 3);

State(1, 1) = 0; % position
State(1, 2) = initialSpeed; % velocity
State(1, 3) = 0; % acceleration

Time = ((1:nrIterations) - 1)'.*deltaTime;
DesiredSpeed = desiredSpeed + 0*sin(0.5.*Time); % Change the zero to have sinusoidal desired speed (for testing)

for i=2:nrIterations
    currPos = State(i-1, 1);
    currVel = State(i-1, 2);
    currAcc = State(i-1, 3);
    
    
    % separate function(s) for generating acceleration request
    accelerationRequest = GetAccelerationRequest(currPos, currVel, currAcc, DesiredSpeed(i));
    
    % Keep acceleration request in a realistic interval
    % also let acceleration decay over time
    actualAcceleration = (currAcc + min(max(accelerationRequest, -accDelta), accDelta))*0.95; % TODO decay does currently not depend on deltaTime!!!
    
    % Keep resulting total acceleration within a realistic interval (based on vehicle characteristics)
    % IRL, this is probably not a "hard boundary", but depends on some sort of decay I guess...
    if (actualAcceleration > maxAcceleration)
        actualAcceleration = maxAcceleration;
    elseif (actualAcceleration > maxDeceleration)
        actualAcceleration = maxDeceleration;
    end
    
    
    % integrating the state
    nextAcc = actualAcceleration;
    nextVel = currVel + currAcc*deltaTime;
    nextPos = currPos + currVel*deltaTime;
    
    State(i,:) = [nextPos, nextVel, nextAcc];
end



%% Plotting
figure;
subplot(3,1,1);
plot(Time, State(:,1));
title('Position');
xlabel('Time');
ylabel('Position');
grid on;

subplot(3,1,2);
plot(Time, State(:,2));
hold on;
plot(Time, DesiredSpeed);
hold off;
title('Velocity');
xlabel('Time');
ylabel('Velocity');
grid on;

subplot(3,1,3);
plot(Time, State(:,3));
title('Acceleration');
xlabel('Time');
ylabel('Acceleration');
grid on;



