function plot_def_shape(POST, MODEL)

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

xlabel('x/l', 'Interpreter','latex', 'FontSize', 20)
ylabel('y/l', 'Interpreter','latex', 'FontSize', 20)

end