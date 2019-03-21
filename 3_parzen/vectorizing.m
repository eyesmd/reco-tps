tic;

SAMP = 1000;
DELT = 0.2;

Dt = stdnormal_rnd([SAMP 1])';
x_est = -2:DELT:2;
y_est = zeros(size(x_est));
for sample = Dt
  y_est += stdnormal_pdf(x_est - sample);
end
y_est /= length(Dt);

toc;
