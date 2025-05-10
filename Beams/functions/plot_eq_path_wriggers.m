function plot_eq_path_wriggers(MODEL, POST_full, POST_vK, node)

[Rows, Cols] = find(MODEL.elements == node);
[Row, Ind] = min(Rows);
Col = Cols(Ind);

u_full  = zeros(length(POST_full.STEP)+1, 1);
w_full  = zeros(length(POST_full.STEP)+1, 1);
P_full  = zeros(length(POST_full.STEP)+1, 1);
lambdas_full = zeros(length(POST_full.STEP)+1, 1);

u_vK  = zeros(length(POST_vK.STEP)+1, 1);
w_vK  = zeros(length(POST_vK.STEP)+1, 1);
P_vK  = zeros(length(POST_vK.STEP)+1, 1);
lambdas_vK = zeros(length(POST_vK.STEP)+1, 1);

for incr = 1 : length(POST_full.STEP)

    STEP_full = POST_full.STEP(incr);
    u_full(incr+1) = STEP_full.u(Row, Col);
    w_full(incr+1) = STEP_full.w(Row, Col);
    P_full(incr+1)   = STEP_full.F;
    lambdas_full(incr+1) = STEP_full.lambda;
end

for incr = 1 : length(POST_vK.STEP)

    STEP_vK = POST_vK.STEP(incr);
    u_vK(incr+1) = STEP_vK.u(Row, Col);
    w_vK(incr+1) = STEP_vK.w(Row, Col);
    P_vK(incr+1)   = STEP_vK.F;
    lambdas_vK(incr+1) = STEP_vK.lambda;
end

figure
hold on 
grid on
plot(u_full, P_full, 'LineWidth', 1.5)
plot(u_vK, P_vK, 'LineWidth', 1.5)
xlabel('$u$', 'Interpreter','latex', 'FontSize',20)
ylabel('$P$', 'Interpreter','latex', 'FontSize', 20)
lgd = legend('full', 'VK');
lgd.Interpreter = 'latex';
lgd.FontSize = 20;
xlim([0 600])
ylim([-20 140])

figure
hold on 
grid on
plot(-w_full, P_full, 'LineWidth', 1.5)
plot(-w_vK, P_vK, 'LineWidth', 1.5)
xlabel('$-w$', 'Interpreter','latex', 'FontSize',20)
ylabel('$P$', 'Interpreter','latex', 'FontSize', 20)
lgd = legend('full', 'VK');
lgd.Interpreter = 'latex';
lgd.FontSize = 20;
xlim([0 600])
ylim([-20 140])

end