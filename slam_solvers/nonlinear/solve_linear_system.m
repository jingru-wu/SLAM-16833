% SOLVE_LINEAR_SYSTEM
% 16-833 Spring 2019 - *Stub* Provided
% Solve the linear system with your method of choice
%
% Arguments: 
%     A     - A matrix from linear system that you generate yourself
%     b     - b vector from linear system that you generate yourself
%
% Returns:
%     x     - solution to the linear system, computed using your method of
%             choice
%
function x = solve_linear_system(A, b)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Your code goes here %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[R,~,s]=chol(A'*A,'vector');
Ab=A'*b;
y = forward_sub(R',Ab(s));
x(s) = back_sub(R, y);
