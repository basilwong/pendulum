function drive_motion()

    % Intial Conditions.
    initial_theta    = 0.2;
    initial_velocity = 0;
    % Constants
    v = 0.5;
    A = 1.465;
    w = 2/3;
    % Time scale for 300 periods.
    maxT = 2*pi*8/w;
    t = [0 maxT];
    
    % Solving the ODE.
    options = odeset('RelTol',1e-4,'AbsTol',1e-4);
    [t,theta]=ode45( @(t,theta) unforcedMotion(t,theta,v,A,w), t, [initial_theta initial_velocity], options);
    
    % theta as function of time
    figure;
    plot(t,theta(:,1));
    xlabel('t'); ylabel('Theta'); title('Theta vs t');
    legend(sprintf('A = %f',A));
    % Phase portrait of theta versus v
    theta(:,1) = perBdyCdn(theta); % Applying periodic boundary conditions.
    figure;
    plot(theta(:,1),theta(:,2));
    xlabel('Theta'); ylabel('Velocity'); title('Phase Portrait (Velocity vs Theta)')
    legend(sprintf('A = %f',A));
    
    % Function for the unforced motion, 2nd order differential equation
    % configured into two 1st order differential equations. 
    function dthetaValue = unforcedMotion(t, theta, v, A, w)
        dtheta1 = theta(2);
        dtheta2 = -v * theta(2) - sin(theta(1)) + A * sin(w*t);

        dthetaValue = [dtheta1; dtheta2];
    end
    
    % Implementing periodic boundary condition. 
    function theta = perBdyCdn(y)
        s = length(y(:,1));
        theta = zeros(s,1);
        % Iterating through each of the vector elements.
        for i = 1:s
            % Different cases for if the value is positive or negative.
            if(y(i,1)>=0)
                temp = y(i,1)/pi;
                if(temp > 1)
                    temp = floor(temp);
                    if( mod(temp,2)==0)
                       theta(i)= mod(y(i,1),pi);
                    else
                        theta(i)=  mod(y(i,1),pi)-pi;
                    end
                else
                    theta(i)=y(i,1);
                end
            else
                temp = y(i,1)/pi;
                if(temp < -1)
                    temp = ceil(temp);
                    if( rem(temp,2)==0)
                       theta(i)= rem(y(i,1),pi);
                    else
                        theta(i)= rem(y(i,1),pi)+pi;
                    end
                  else
                    theta(i)=y(i,1);
                end
            end
        end

    end

end