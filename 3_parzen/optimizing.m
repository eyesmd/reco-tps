tic;

SAMP = 1000;
DELT = 0.2;

D = stdnormal_rnd([SAMP 1]);
x_est = -2:DELT:2;
y_est = [];
for j = 1:length(x_est)
    summation = 0;
    for i = 1:length(D)
      summation += stdnormal_pdf(x_est(j) - D(i));
    end
    y_est(j) = summation / length(D);
end

toc;
