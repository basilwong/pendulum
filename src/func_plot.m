% Makes plots of ? as function of time, as well as phase portraits of theta
% versus v. 
function func_plot()
    
    % Intial Conditions.
    initial_theta    = 0.2;
    initial_velocity = 0;
    % Constants
    v = 10;
    % Time Scale
    t = [0 80];

    % Solving the ODE.
    [t,theta]=ode45( @(t,theta) unforcedMotion(t,theta,v), t, [initial_theta initial_velocity] );
    
    % theta as function of time
    figure;
    plot(t,theta(:,1));
    xlabel('t'); ylabel('Theta'); title('Theta vs t');
    legend(sprintf('v = %d',v));
    % Phase portrait of theta versus v
    figure;
    plot(theta(:,1),theta(:,2));
    xlabel('Theta'); ylabel('Velocity'); title('Phase Portrait (Velocity vs Theta)')
    legend(sprintf('v = %d',v));

    % Function for the unforced motion, 2nd order differential equation
    % configured into two 1st order differential equations. 
    function dthetaValue = unforcedMotion(t, theta, v)
        dtheta1 = theta(2);
        dtheta2 = -v * theta(2) - sin(theta(1));

        dthetaValue = [dtheta1; dtheta2];
    end
end