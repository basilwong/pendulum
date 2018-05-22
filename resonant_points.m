% Making phase space plots using only resonant points. 
function theta = Phys410Project3Part5()

    % Intial Conditions.
    initial_theta    = 0.2;
    initial_velocity = 0;
    % Constants
    v = 0.5;
    A = 1.465;
    w = 2/3;
    n = 2000;
    % Time scale for 300 periods.
    t = (2*pi/w):(2*pi/w):(2*pi/w*n);
    t2 = [(2*pi/w) (2*pi/w*n)];
    
    % Solving the ODE.
    options = odeset('RelTol',1e-9,'AbsTol',1e-12);
    [t,theta]=ode45( @(t,theta) unforcedMotion(t,theta,v,A,w), t, [initial_theta initial_velocity], options);
    [t2,theta_full]=ode45( @(t2,theta) unforcedMotion(t2,theta,v,A,w), t2, [initial_theta initial_velocity], options);

    theta(:,1) = perBdyCdn(theta);
    %Plotting  Theta(2*pi*n/w) vs n:
    nList = 1:1:n;
    figure;
    plot(nList,theta(:,1))
    xlabel('n'); ylabel('Theta'); title('Theta vs n'); legend(sprintf('A = %f',A));
    theta = perBdyCdn(theta);
%     figure;
%     hold on
%     plot(theta(:,1),theta(:,2));
%     plot(theta_full(:,1),theta_full(:,2));
%     hold off

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

    for i = 1:s
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
                if( rem(temp,2)==0)%even
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