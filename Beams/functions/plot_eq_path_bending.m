function plot_eq_path_bending(POST, MODEL)

EJ = MODEL.EJ;

u_tip = zeros(length(POST.STEP)+1, 1);
w_tip = zeros(length(POST.STEP)+1, 1);
u_tip_ad = zeros(length(POST.STEP)+1, 1);
w_tip_ad = zeros(length(POST.STEP)+1, 1);
Pcr   = zeros(length(POST.STEP)+1, 1);
lambdas = zeros(length(POST.STEP)+1, 1);

for incr = 1 : length(POST.STEP)

    STEP = POST.STEP(incr);
    L = STEP.X(end, end) - STEP.X(1, 1);
    u_tip(incr+1) = STEP.u(end, end);
    w_tip(incr+1) = STEP.w(end, end);
    u_tip_ad(incr+1) = STEP.u(end, end)/L;
    w_tip_ad(incr+1) = STEP.w(end, end)/L;
    F = STEP.F;
    Pcr(incr+1)   = F*L^2/EJ;
    lambdas(incr+1) = STEP.lambda;
end

figure
hold on
grid on
plot(-u_tip_ad, Pcr, 'LineWidth', 1.5)
plot(w_tip_ad, Pcr, 'LineWidth', 1.5)
xlabel('$-u_{tip}/l, \ w_{tip}/l$', 'Interpreter','latex', 'FontSize', 20)
ylabel('$Pl^2/EJ$', 'Interpreter','latex', 'FontSize', 20)
lgd = legend('$-u_{tip}/l$', '$w_{tip}/l$');
lgd.Interpreter = 'latex';
lgd.FontSize = 20;
xlim([0, 1])
ylim([0, 10])

tab = table(lambdas, u_tip, w_tip, 'VariableNames', {'lambda', 'u_tip', 'w_tip'});
disp(tab);
