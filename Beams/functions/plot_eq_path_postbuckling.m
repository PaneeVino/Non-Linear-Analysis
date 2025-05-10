function plot_eq_path_postbuckling(POST_full, MODEL_full, POST_vK)

EJ = MODEL_full.EJ;

u_tip_full = zeros(length(POST_full.STEP)+1, 1);
w_tip_full = zeros(length(POST_full.STEP)+1, 1);
u_tip_ad_full = zeros(length(POST_full.STEP)+1, 1);
w_tip_ad_full = zeros(length(POST_full.STEP)+1, 1);
Pcr_full   = zeros(length(POST_full.STEP)+1, 1);
lambdas_full = zeros(length(POST_full.STEP)+1, 1);

u_tip_vK = zeros(length(POST_vK.STEP)+1, 1);
w_tip_vK = zeros(length(POST_vK.STEP)+1, 1);
u_tip_ad_vK = zeros(length(POST_vK.STEP)+1, 1);
w_tip_ad_vK = zeros(length(POST_vK.STEP)+1, 1);
Pcr_vK   = zeros(length(POST_vK.STEP)+1, 1);
lambdas_vK = zeros(length(POST_vK.STEP)+1, 1);

for incr = 1 : length(POST_full.STEP)

    STEP_full = POST_full.STEP(incr);
    L = STEP_full.X(end, end) - STEP_full.X(1, 1);
    u_tip_full(incr+1) = STEP_full.u(end, end);
    w_tip_full(incr+1) = STEP_full.w(end, end);
    u_tip_ad_full(incr+1) = STEP_full.u(end, end)/L;
    w_tip_ad_full(incr+1) = STEP_full.w(end, end)/L;
    F = STEP_full.F;
    Pcr_full(incr+1)   = 4/pi^2 * F*L^2/EJ;
    lambdas_full(incr+1) = STEP_full.lambda;
end

for incr = 1 : length(POST_vK.STEP)

    STEP_vK = POST_vK.STEP(incr);
    L = STEP_vK.X(end, end) - STEP_vK.X(1, 1);
    u_tip_vK(incr+1)    = STEP_vK.u(end, end);
    w_tip_vK(incr+1)    = STEP_vK.w(end, end);
    u_tip_ad_vK(incr+1) = STEP_vK.u(end, end)/L;
    w_tip_ad_vK(incr+1) = STEP_vK.w(end, end)/L;
    F = STEP_vK.F;
    Pcr_vK(incr+1)   = 4/pi^2 * F*L^2/EJ;
    lambdas_vK(incr+1) = STEP_vK.lambda;
end

figure
hold on 
grid on
plot(-u_tip_ad_full, Pcr_full, 'LineWidth', 1.5)
plot(-u_tip_ad_vK, Pcr_vK, 'LineWidth', 1.5)
xlabel('$-u_{tip}/l$', 'Interpreter','latex', 'FontSize',20)
ylabel('$P/P_{cr}$', 'Interpreter','latex', 'FontSize', 20)
lgd = legend('full', 'VK');
lgd.Interpreter = 'latex';
lgd.FontSize = 20;
xlim([0 1])
ylim([0 5])

figure
hold on 
grid on
plot(w_tip_ad_full, Pcr_full, 'LineWidth', 1.5)
plot(w_tip_ad_vK, Pcr_vK, 'LineWidth', 1.5)
xlabel('$w_{tip}/l$', 'Interpreter','latex', 'FontSize', 20)
ylabel('$P/P_{cr}$', 'Interpreter','latex', 'FontSize', 20)
lgd = legend('full', 'VK');
lgd.Interpreter = 'latex';
lgd.FontSize = 20;
xlim([0 1])
ylim([0 5])
xlim([0 1])
ylim([0 5])

end