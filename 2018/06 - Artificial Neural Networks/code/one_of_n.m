%this is a helper function that truns an integer to one-hot vector
function [ b ] = one_of_n( a )
  mina = min(a);
  maxa = max(a);
  b = zeros(size(a,1), maxa);
  for i = mina:maxa
      b(:,i) = (a == i);
  end
end

