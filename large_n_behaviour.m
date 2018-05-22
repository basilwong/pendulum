% Exploring large n behaviour.
function large_n_behaviour()
    % Configure the number of points within the range. 
    points1 = 20;
    points2 = 20;
    total = points1 + points2;
    % The range of amplitudes.
    AList1 = [linspace(0.5,1.0,points1) linspace(1,1.2,points2)];
    AList2 = [linspace(1.35,1.47,points1) linspace(1.47,1.5,points2)];
    % Initiating the average and error arrays for the plots.
    averageArray1 = zeros(total,1);
    averageArray2 = zeros(total,1);
    errorArray1 = zeros(total,1);
    errorArray2 = zeros(total,1);
        
    for i = 1:total
        % Temporary theta solution array 1. 
        temp = solveForTheta(AList1(i));
        averageArray1(i) = mean(temp(end-50:end)); % Getting the average of the last 50 n.
        errorArray1(i) = std(temp(end-50:end)); % Getting the standard deviation of the last 50 n.
        % Temporary theta solution array 2. 
        temp = solveForTheta(AList2(i));
        averageArray2(i) = mean(temp(end-50:end)); % Getting the average of the last 50 n.
        errorArray2(i) = std(temp(end-50:end)); % Getting the standard deviation of the last 50 n.
    end
    
    % Plotting for the first range of amplitudes  0.5 ? A ? 1.2
    figure;
    errorbar(AList1,averageArray1,errorArray1,'o');
    xlabel('A (amplitude'); ylabel('Theta(2pi*n/w)'); title('Theta(2pi*n/w) vs 0.5 < A < 1.2(Error Bars show convergence)');
    % Plotting for the first range of amplitudes  1.35 ? A ? 1.5 
    figure;
    errorbar(AList2,averageArray2,errorArray2,'o');
    xlabel('A (amplitude'); ylabel('Theta(2pi*n/w)'); title('Theta(2pi*n/w) vs 1.35 < A < 1.5(Error Bars show convergence)');
    
%% Function returns theta solution array for given amplitude A.
    function thetaArray = solveForTheta(A)
        
        % Intial Conditions.
        initial_theta    = 0.2;
        initial_velocity = 0;
        % Constants
        v = 0.5;
        w = 2/3;
        n = 500;
        % Time scale for 300 periods.
        t = (2*pi/w):(2*pi/w):(2*pi/w*n);

        % Solving the ODE.
        options = odeset('RelTol',1e-9,'AbsTol',1e-12);
        [t,theta]=ode45( @(t,theta) unforcedMotion(t,theta,v,A,w), t, [initial_theta initial_velocity], options);
        
        thetaArray = theta(:,1);
        % Function for the unforced motion, 2nd order differential equation
        % configured into two 1st order differential equations. 
        function dthetaValue = unforcedMotion(t, theta, v, A, w)
            dtheta1 = theta(2);
            dtheta2 = -v * theta(2) - sin(theta(1)) + A * sin(w*t);

            dthetaValue = [dtheta1; dtheta2];
        end
    end
end