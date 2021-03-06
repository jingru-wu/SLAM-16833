% ERROR_NONLINEAR
% 16-833 Spring 2019 - *Stub* Provided
% Computes the total error of all measurements (odometry and landmark)
% given the current state estimate
%
% Arguments: 
%     x       - Current estimate of the state vector
%     odom    - Matrix that contains the odometry measurements
%               between consecutive poses. Each row corresponds to
%               a measurement. 
%                 odom(:,1) - x-value of odometry measurement
%                 odom(:,2) - y-value of odometry measurement
%     obs     - Matrix that contains the landmark measurements and
%               relevant information. Each row corresponds to a
%               measurement.
%                 obs(:,1) - idx of pose at which measurement was 
%                   made
%                 obs(:,2) - idx of landmark being observed
%                 obs(:,3) - bearing theta of landmark measurement
%                 obs(:,4) - range d of landmark measurement
%     sigma_o - Covariance matrix corresponding to the odometry
%               measurements
%     sigma_l - Covariance matrix corresponding to the landmark
%               measurements
% Returns:
%     err     - total error of all measurements
%
function err = error_nonlinear(x, odom, obs, sigma_odom, sigma_landmark)
%% Extract useful constants which you may wish to use
n_poses = size(odom, 1) + 1;                % +1 for prior on the first pose
n_landmarks = max(obs(:,2));

n_odom = size(odom, 1);
n_obs  = size(obs, 1);

% Dimensions of state variables and measurements (all 2 in this case)
p_dim = 2;                                  % pose dimension
l_dim = 2;                                  % landmark dimension
o_dim = size(odom, 2);                      % odometry dimension
m_dim = size(obs(1, 3:end), 2);    % landmark measurement dimension

% A matrix is MxN, b is Nx1
N = p_dim*n_poses + l_dim*n_landmarks;
M = o_dim*(n_odom+1) + m_dim*n_obs;         % +1 for prior on the first pose

%% Initialize error
err = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Your code goes here %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : (n_odom+n_obs)
    if i<=(n_odom) % pose error
        pose = odom(i, :);
        Rx_pre=x((i-1)*2+1);
        Ry_pre=x((i-1)*2+2);
        Rx_current=x((i-1)*2+3);
        Ry_current=x((i-1)*2+4);
        opse_est = meas_odom(Rx_pre, Ry_pre, Rx_current, Ry_current);
        pose_err = pose - opse_est';
        err = err + sum(pose_err.^ 2);
    end
    if i>(n_odom)
        obs_i=obs(i-n_odom, :);
        pose_idx = obs_i(1);
        land_idx = obs_i(2);
        land_mea = obs_i(3 : 4);
        pose_est = x(pose_idx * 2 - 1 : pose_idx * 2);
        land_est = x(2*n_odom+2*land_idx+1 : 2*n_odom+ 2*land_idx+2);
        
        land_mea_est = meas_landmark(pose_est(1), pose_est(2), land_est(1), land_est(2));
    
       err = err + wrapToPi(land_mea(1) - land_mea_est(1)) ^ 2 + (land_mea(2) - land_mea_est(2)) ^ 2;
    end
end

