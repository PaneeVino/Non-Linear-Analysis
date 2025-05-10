function post_process(POST, MODEL)

figure
hold on
axis equal

for incr = 1 : length(POST.STEP)

    STEP = POST.STEP(incr);
    xx = STEP.x;
    yy = STEP.y;

    L = STEP.X(end, end) - STEP.X(1, 1);

    for i = 1 : MODEL.nels

        x = xx(i, :);
        y = yy(i, :);

        plot(x/L, y/L, 'Color', 'k')

    end

end

xlabel('x/l', 'Interpreter','latex')
ylabel('y/l', 'Interpreter','latex')

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
    Pcr(incr+1)   = 4/pi^2 * F*L^2/EJ;
    lambdas(incr+1) = STEP.lambda;
end

figure
hold on
plot(-u_tip_ad, Pcr)
plot(w_tip_ad, Pcr)
xlabel('$-u_{tip}/l, \ w_{tip}/l$', 'Interpreter','latex')
ylabel('$Pl^2/EJ$', 'Interpreter','latex')
xlim([0, 1])
ylim([0, 10])

tab = table(lambdas, u_tip, w_tip, 'VariableNames', {'lambda', 'u_tip', 'w_tip'});
disp(tab);

end