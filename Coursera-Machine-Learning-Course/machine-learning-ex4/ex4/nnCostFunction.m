function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%Activation of first input layer 5000x400
a1 = X;
%Adding bias term 5000x401
a1 = [ones(m,1) a1];
%Computation with weights 5000x26
z2 = a1*Theta1';
%Activation of second layer 5000x25
a2 = sigmoid(z2);

m2 = size(a2, 1);
%Adding bias term
a2 = [ones(m2,1) a2];
%Computation with weights 5000x10
z3 = a2*Theta2';
%Activation of third() in this case final layer 5000x10
a3 = sigmoid(z3);

%Final output(5000x10):
h = a3;                                                            

%Declaring y1s which is y in theform of a correct value matrix 5000x10                                
y1s = zeros(m, num_labels);                                                      
for i=1:size(y, 1)
    j=y(i,1);
    y1s(i,j)=1;    
end

%Cost function
J_ex = -y1s.*log(h) - (1 - y1s).*log(1-h) ;                                 %Cost function for one example

J_unreg = (1/m)*sum(sum(J_ex));                                             %Unregularised Cost Function

Reg_factor = (lambda/(2*m))*(sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)));

J = J_unreg + Reg_factor;                                                   %Final Cost function

%------------------------------------------------------------------------------------------------------------------------
%Gradient

Del1 = zeros(size(Theta1));
Del2 = zeros(size(Theta2));

for i=1:m
    d3 = h(i,:) - y1s(i,:);
    
    d2 = d3*Theta2;
    d2 = d2(:,2:end);
    d2 = d2.*sigmoidGradient(z2(i,:));
    
    Del2 = Del2 + d3'*a2(i,:); 
    
    Del1 = Del1 + d2'*a1(i,:);
end

Theta1_grad = (1.0/m)*Del1;

Theta2_grad = (1.0/m)*Del2;

%Regularised Gradient:

Theta1_grad(:,2:end) = (1/m)*Del1(:,2:end) + (lambda/m)*Theta1(:,2:end);

Theta2_grad(:,2:end) = (1/m)*Del2(:,2:end) + (lambda/m)*Theta2(:,2:end);
% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
