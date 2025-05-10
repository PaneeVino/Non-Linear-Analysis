function POST = post_process(MODEL, POST)

POST.cmap = jet;

switch length(POST.STEP)

    case 1

        scale_factor = 300;

        figure  % Create a new figure for displacement visualization
        hold on
        axis equal
        grid on

        % Loop over all elements to visualize the displacement for each element
        for k = 1 : MODEL.nels
            % Get the original coordinates of the nodes of the element
            X = POST.STEP(1).X(k, :);
            Y = POST.STEP(1).Y(k, :);

            % Get the displacement components for the element nodes
            Ux = POST.STEP(1).Ux(k, :);
            Uy = POST.STEP(1).Uy(k, :);

            % Apply the displacement to the original coordinates to get updated positions
            X_upd = X + scale_factor * Ux;
            Y_upd = Y + scale_factor * Uy;

            % Prepare vertices and faces for plotting the undeformed and deformed shapes
            vert_undeformed = [X; Y].';
            vert_deformed = [X_upd; Y_upd].';
            element = [1, 2, 3, 4];  % Quad element indices (assuming quadrilateral elements)

            % --- Plot the undeformed shape (transparent edges and faces) ---
            patch('vertices', vert_undeformed, 'faces', element, ...
                'FaceColor', 'none', ...           % No face color
                'FaceAlpha', 0.3, ...           % Transparency for face
                'EdgeColor', [0, 0, 0], ...     % Black edges
                'LineWidth', 0.8, ...
                'EdgeAlpha', 0.3);              % Transparency for edges

            % --- Plot the deformed shape ---
            patch('vertices', vert_deformed, 'faces', element, ...
                'FaceColor', 'none', ...           % No face color
                'EdgeColor', 'k', ...           % Black edges
                'LineWidth', 1);              % Thicker black edges
        end

        % Figure title and adjustments
        title('Undeformed Shape (Transparent) and Deformed Shape');
        xlabel('X [mm]'); ylabel('Y [mm]');

        figure  % Create a new figure for displacement visualization
        hold on
        axis equal
        grid on

        % Loop over all elements to visualize the displacement for each element
        for k = 1 : MODEL.nels
            % Get the original coordinates of the nodes of the element
            X = POST.STEP(1).X(k, :);
            Y = POST.STEP(1).Y(k, :);

            % Get the displacement components for the element nodes
            Ux = POST.STEP(1).Ux(k, :);
            Uy = POST.STEP(1).Uy(k, :);

            % Apply the displacement to the original coordinates to get updated positions
            X_upd = X + scale_factor * Ux;
            Y_upd = Y + scale_factor * Uy;

            % Calculate the total displacement magnitude for color-coding
            U_tot = POST.STEP(1).U_tot(k, :);

            % Prepare the vertices and faces for plotting the element (quadrilateral)
            vert = [X_upd; Y_upd].';
            element = [1, 2, 3, 4];  % Quad element indices (assuming quadrilateral elements)

            % Create the patch (colored element) based on displacement magnitude
            patch('vertices', vert, 'faces', element, 'FaceVertexCData', U_tot.', 'facecolor', 'interp')
        end

        % Add a colorbar for the total displacement magnitude
        hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(1).U_tot)), max(max(POST.STEP(1).U_tot)), 5));
        hcb.FontSize = 15;
        colormap(POST.cmap)
        set(hcb, 'TickLabelInterpreter', 'latex');
        clim([min(min(POST.STEP(1).U_tot)) max(max(POST.STEP(1).U_tot))])  % Set color limits based on displacement range
        title(hcb, '$U_{tot}$ [mm]', 'interpreter', 'latex', 'fontsize', 20)



        % % --- Recover and visualize stresses
        % POST = recover_stresses(POST, MODEL, MATERIAL);

        % Visualization of the stress results (sigma_xx)
        figure
        hold on
        axis equal
        grid on
        for k = 1 : MODEL.nels
            % Get the element node coordinates and displacements
            X = POST.STEP(1).X(k, :);
            Y = POST.STEP(1).Y(k, :);
            Ux = POST.STEP(1).Ux(k, :);
            Uy = POST.STEP(1).Uy(k, :);

            % Update the node positions with displacements applied
            X_upd = X + scale_factor * Ux;
            Y_upd = Y + scale_factor * Uy;

            % Get the stress component sigma_xx for the element
            Sxx = POST.STEP(1).sigmaxx_nod(k, :);

            % Prepare the vertices and faces for plotting the element
            vert = [X_upd; Y_upd].';
            element = [1, 2, 3, 4];

            % Create the patch for sigma_xx with color-coded stress values
            patch('vertices', vert, 'faces', element, 'FaceVertexCData', Sxx.', 'facecolor', 'interp')
        end

        % Add a colorbar for sigma_xx
        hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(1).sigmaxx_nod)), max(max(POST.STEP(1).sigmaxx_nod)), 5));
        hcb.FontSize = 15;
        colormap(POST.cmap)
        set(hcb, 'TickLabelInterpreter', 'latex');
        clim([min(min(POST.STEP(1).sigmaxx_nod)) max(max(POST.STEP(1).sigmaxx_nod))])  % Set color limits based on stress range
        title(hcb, '$\sigma_{xx}$ [MPa]', 'interpreter', 'latex', 'fontsize', 20)

        % Visualization of the stress results (sigma_yy)
        figure
        hold on
        axis equal
        grid on
        for k = 1 : MODEL.nels
            % Same process as before for sigma_yy
            X = POST.STEP(1).X(k, :);
            Y = POST.STEP(1).Y(k, :);
            Ux = POST.STEP(1).Ux(k, :);
            Uy = POST.STEP(1).Uy(k, :);
            X_upd = X + scale_factor * Ux;
            Y_upd = Y + scale_factor * Uy;
            Syy = POST.STEP(1).sigmayy_nod(k, :);
            vert = [X_upd; Y_upd].';
            patch('vertices', vert, 'faces', element, 'FaceVertexCData', Syy.', 'facecolor', 'interp')
        end

        % Add a colorbar for sigma_yy
        hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(1).sigmayy_nod)), max(max(POST.STEP(1).sigmayy_nod)), 5));
        hcb.FontSize = 15;
        colormap(POST.cmap)
        set(hcb, 'TickLabelInterpreter', 'latex');
        clim([min(min(POST.STEP(1).sigmayy_nod)) max(max(POST.STEP(1).sigmayy_nod))])
        title(hcb, '$\sigma_{yy}$ [MPa]', 'interpreter', 'latex', 'fontsize', 20)

        % Visualization of the stress results (sigma_xy)
        figure
        hold on
        axis equal
        grid on
        for k = 1 : MODEL.nels
            % Same process as before for sigma_xy
            X = POST.STEP(1).X(k, :);
            Y = POST.STEP(1).Y(k, :);
            Ux = POST.STEP(1).Ux(k, :);
            Uy = POST.STEP(1).Uy(k, :);
            X_upd = X + scale_factor * Ux;
            Y_upd = Y + scale_factor * Uy;
            Sxy = POST.STEP(1).sigmaxy_nod(k, :);
            vert = [X_upd; Y_upd].';
            patch('vertices', vert, 'faces', element, 'FaceVertexCData', Sxy.', 'facecolor', 'interp')
        end

        % Add a colorbar for sigma_xy
        hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(1).sigmaxy_nod)), max(max(POST.STEP(1).sigmaxy_nod)), 5));
        hcb.FontSize = 15;
        colormap(POST.cmap)
        set(hcb, 'TickLabelInterpreter', 'latex');
        clim([min(min(POST.STEP(1).sigmaxy_nod)) max(max(POST.STEP(1).sigmaxy_nod))])
        title(hcb, '$\sigma_{xy}$ [MPa]', 'interpreter', 'latex', 'fontsize', 20)

    otherwise

        dim = MODEL.dim;

        scale_factor = 1;

        % Define subplot positions manually
        positions = [
            0.05, 0.55, 0.27, 0.4;  % Top-left
            0.37, 0.55, 0.27, 0.4;  % Top-center
            0.69, 0.55, 0.27, 0.4;  % Top-right
            0.23, 0.05, 0.27, 0.4;  % Bottom-left
            0.53, 0.05, 0.27, 0.4;  % Bottom-right
            ];

        l = length(POST.STEP);
        steps = ceil(linspace(1, l, 5)); %to be changed for generality purposes

        switch dim

            case 2

                figure;
                sgtitle('Deformed Shape', 'FontSize', 16, 'Interpreter', 'latex');

                % Loop through steps for multiple subplots
                for i = 1 : length(steps)
                    step = steps(i);
                    lambda = POST.STEP(step).lambda;

                    % Create axes for each subplot
                    axes('Position', positions(i, :));
                    hold on;
                    axis equal;
                    grid on;
                    title(sprintf('$\\lambda = %.2f$', lambda), 'FontSize', 12, 'Interpreter', 'latex');

                    % Loop over all elements
                    for k = 1 : MODEL.nels
                        % Get original coordinates (undeformed shape)
                        X = POST.STEP(step).X(k, :);
                        Y = POST.STEP(step).Y(k, :);

                        % Get displacement components
                        Ux = POST.STEP(step).Ux(k, :);
                        Uy = POST.STEP(step).Uy(k, :);

                        % Updated coordinates for deformed shape
                        X_upd = X + scale_factor * Ux;
                        Y_upd = Y + scale_factor * Uy;

                        % Vertices and element faces
                        vert_undeformed = [X; Y].';
                        vert_deformed = [X_upd; Y_upd].';
                        element = [1, 2, 3, 4];  % Quad element indices

                        % --- Plot undeformed shape (transparent edges) ---
                        patch('Vertices', vert_undeformed, 'Faces', element, ...
                            'FaceColor', 'none', ...       % No face color
                            'EdgeColor', [0, 0, 0], ...    % Black edges
                            'LineWidth', 0.5, ...
                            'EdgeAlpha', 0.3);             % Transparent edges

                        % --- Plot deformed shape (solid black edges) ---
                        patch('Vertices', vert_deformed, 'Faces', element, ...
                            'FaceColor', 'none', ...       % No face color
                            'EdgeColor', 'k', ...          % Solid black edges
                            'LineWidth', 1.0);
                    end
                end


                figure;
                sgtitle('Total Displacement [mm]', 'FontSize', 16, 'Interpreter', 'latex');
                for i = 1 : length(steps)

                    step = steps(i);
                    lambda = POST.STEP(step).lambda;
                    % Create an axes object for each subplot
                    axes('Position', positions(i, :));
                    hold on;
                    axis equal;
                    grid on;
                    title(sprintf('$\\lambda$ = %.2f', lambda), 'FontSize', 12, 'Interpreter', 'latex');


                    % Loop over all elements to visualize the displacement for each element
                    for k = 1 : MODEL.nels
                        % Get the original coordinates of the nodes of the element
                        X = POST.STEP(step).X(k, :);
                        Y = POST.STEP(step).Y(k, :);

                        % Get the displacement components for the element nodes
                        Ux = POST.STEP(step).Ux(k, :);
                        Uy = POST.STEP(step).Uy(k, :);

                        % Apply the displacement to the original coordinates to get updated positions
                        X_upd = X + scale_factor * Ux;
                        Y_upd = Y + scale_factor * Uy;

                        % Calculate the total displacement magnitude for color-coding
                        U_tot = POST.STEP(step).U_tot(k, :);

                        % Prepare the vertices and faces for plotting the element (quadrilateral)
                        vert = [X_upd; Y_upd].';
                        element = [1, 2, 3, 4];  % Quad element indices (assuming quadrilateral elements)

                        % Create the patch (colored element) based on displacement magnitude
                        patch('vertices', vert, 'faces', element, 'FaceVertexCData', U_tot.', 'facecolor', 'interp')
                    end

                    hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(step).U_tot)), max(max(POST.STEP(step).U_tot)), 5));
                    hcb.FontSize = 15;
                    colormap(POST.cmap)
                    set(hcb, 'TickLabelInterpreter', 'latex');
                    clim([min(min(POST.STEP(step).U_tot)) max(max(POST.STEP(step).U_tot))])  % Set color limits based on displacement range

                end

                figure;
                sgtitle('$\sigma_{xx}$ [MPa]', 'FontSize', 16, 'Interpreter', 'latex');
                for i = 1 : length(steps)

                    step = steps(i);
                    lambda = POST.STEP(step).lambda;
                    % Create an axes object for each subplot
                    axes('Position', positions(i, :));
                    hold on;
                    axis equal;
                    grid on;
                    title(sprintf('$\\lambda$ = %.2f', lambda), 'FontSize', 12, 'Interpreter', 'latex');


                    % Loop over all elements to visualize the displacement for each element
                    for k = 1 : MODEL.nels
                        % Get the original coordinates of the nodes of the element
                        X = POST.STEP(step).X(k, :);
                        Y = POST.STEP(step).Y(k, :);

                        % Get the displacement components for the element nodes
                        Ux = POST.STEP(step).Ux(k, :);
                        Uy = POST.STEP(step).Uy(k, :);

                        % Apply the displacement to the original coordinates to get updated positions
                        X_upd = X + scale_factor * Ux;
                        Y_upd = Y + scale_factor * Uy;

                        % Get the stress component sigma_xx for the element
                        Sxx = POST.STEP(step).sigmaxx_nod(k, :);

                        % Prepare the vertices and faces for plotting the element (quadrilateral)
                        vert = [X_upd; Y_upd].';
                        element = [1, 2, 3, 4];  % Quad element indices (assuming quadrilateral elements)

                        % Create the patch (colored element) based on displacement magnitude
                        patch('vertices', vert, 'faces', element, 'FaceVertexCData', Sxx.', 'facecolor', 'interp')
                    end

                    hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(step).sigmaxx_nod)), max(max(POST.STEP(step).sigmaxx_nod)), 5));
                    hcb.FontSize = 15;
                    colormap(POST.cmap)
                    set(hcb, 'TickLabelInterpreter', 'latex');
                    clim([min(min(POST.STEP(step).sigmaxx_nod)) max(max(POST.STEP(step).sigmaxx_nod))])  % Set color limits based on displacement range

                end

                figure;
                sgtitle('$\sigma_{yy}$ [MPa]', 'FontSize', 16, 'Interpreter', 'latex');
                for i = 1 : length(steps)

                    step = steps(i);
                    lambda = POST.STEP(step).lambda;
                    % Create an axes object for each subplot
                    axes('Position', positions(i, :));
                    hold on;
                    axis equal;
                    grid on;
                    title(sprintf('$\\lambda$ = %.2f', lambda), 'FontSize', 12, 'Interpreter', 'latex');


                    % Loop over all elements to visualize the displacement for each element
                    for k = 1 : MODEL.nels
                        % Get the original coordinates of the nodes of the element
                        X = POST.STEP(step).X(k, :);
                        Y = POST.STEP(step).Y(k, :);

                        % Get the displacement components for the element nodes
                        Ux = POST.STEP(step).Ux(k, :);
                        Uy = POST.STEP(step).Uy(k, :);

                        % Apply the displacement to the original coordinates to get updated positions
                        X_upd = X + scale_factor * Ux;
                        Y_upd = Y + scale_factor * Uy;

                        % Get the stress component sigma_xx for the element
                        Syy = POST.STEP(step).sigmayy_nod(k, :);

                        % Prepare the vertices and faces for plotting the element (quadrilateral)
                        vert = [X_upd; Y_upd].';
                        element = [1, 2, 3, 4];  % Quad element indices (assuming quadrilateral elements)

                        % Create the patch (colored element) based on displacement magnitude
                        patch('vertices', vert, 'faces', element, 'FaceVertexCData', Syy.', 'facecolor', 'interp')
                    end

                    hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(step).sigmayy_nod)), max(max(POST.STEP(step).sigmayy_nod)), 5));
                    hcb.FontSize = 15;
                    colormap(POST.cmap)
                    set(hcb, 'TickLabelInterpreter', 'latex');
                    clim([min(min(POST.STEP(step).sigmayy_nod)) max(max(POST.STEP(step).sigmayy_nod))])  % Set color limits based on displacement range

                end

                figure;
                sgtitle('$\sigma_{xy}$ [MPa]', 'FontSize', 16, 'Interpreter', 'latex');
                for i = 1 : length(steps)

                    step = steps(i);
                    lambda = POST.STEP(step).lambda;
                    % Create an axes object for each subplot
                    axes('Position', positions(i, :));
                    hold on;
                    axis equal;
                    grid on;
                    title(sprintf('$\\lambda$ = %.2f', lambda), 'FontSize', 12, 'Interpreter', 'latex');


                    % Loop over all elements to visualize the displacement for each element
                    for k = 1 : MODEL.nels
                        % Get the original coordinates of the nodes of the element
                        X = POST.STEP(step).X(k, :);
                        Y = POST.STEP(step).Y(k, :);

                        % Get the displacement components for the element nodes
                        Ux = POST.STEP(step).Ux(k, :);
                        Uy = POST.STEP(step).Uy(k, :);

                        % Apply the displacement to the original coordinates to get updated positions
                        X_upd = X + scale_factor * Ux;
                        Y_upd = Y + scale_factor * Uy;

                        % Get the stress component sigma_xx for the element
                        Sxy = POST.STEP(step).sigmaxy_nod(k, :);

                        % Prepare the vertices and faces for plotting the element (quadrilateral)
                        vert = [X_upd; Y_upd].';
                        element = [1, 2, 3, 4];  % Quad element indices (assuming quadrilateral elements)

                        % Create the patch (colored element) based on displacement magnitude
                        patch('vertices', vert, 'faces', element, 'FaceVertexCData', Sxy.', 'facecolor', 'interp')
                    end

                    hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(step).sigmaxy_nod)), max(max(POST.STEP(step).sigmaxy_nod)), 5));
                    hcb.FontSize = 15;
                    colormap(POST.cmap)
                    set(hcb, 'TickLabelInterpreter', 'latex');
                    clim([min(min(POST.STEP(step).sigmaxy_nod)) max(max(POST.STEP(step).sigmaxy_nod))])  % Set color limits based on displacement range

                end

                            figure;
                sgtitle('$\sigma_{VM}$ [MPa]', 'FontSize', 16, 'Interpreter', 'latex');
                for i = 1 : length(steps)

                    step = steps(i);
                    lambda = POST.STEP(step).lambda;
                    % Create an axes object for each subplot
                    axes('Position', positions(i, :));
                    hold on;
                    axis equal;
                    grid on;
                    title(sprintf('$\\lambda$ = %.2f', lambda), 'FontSize', 12, 'Interpreter', 'latex');


                    % Loop over all elements to visualize the displacement for each element
                    for k = 1 : MODEL.nels
                        % Get the original coordinates of the nodes of the element
                        X = POST.STEP(step).X(k, :);
                        Y = POST.STEP(step).Y(k, :);

                        % Get the displacement components for the element nodes
                        Ux = POST.STEP(step).Ux(k, :);
                        Uy = POST.STEP(step).Uy(k, :);

                        % Apply the displacement to the original coordinates to get updated positions
                        X_upd = X + scale_factor * Ux;
                        Y_upd = Y + scale_factor * Uy;

                        % Get the stress component sigma_xx for the element
                        Svm = POST.STEP(step).sigmavm_nod(k, :);

                        % Prepare the vertices and faces for plotting the element (quadrilateral)
                        vert = [X_upd; Y_upd].';
                        element = [1, 2, 3, 4];  % Quad element indices (assuming quadrilateral elements)

                        % Create the patch (colored element) based on displacement magnitude
                        patch('vertices', vert, 'faces', element, 'FaceVertexCData', Svm.', 'facecolor', 'interp')
                    end

                    hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(step).sigmavm_nod)), max(max(POST.STEP(step).sigmavm_nod)), 5));
                    hcb.FontSize = 15;
                    colormap(POST.cmap)
                    set(hcb, 'TickLabelInterpreter', 'latex');
                    clim([min(min(POST.STEP(step).sigmavm_nod)) max(max(POST.STEP(step).sigmavm_nod))])  % Set color limits based on displacement range

                end

            case 3

                faces = [1  9 2 18 6 13 5 17;
                    2 10 3 19 7 14 6 18;
                    3 11 4 20 8 15 7 19;
                    4 20 8 16 5 17 1 12;
                    8 15 7 14 6 13 5 16;
                    4 11 3 10 2  9 1 12];
                nfaces = size(faces, 1);

                figure;
                sgtitle('Deformed Shape', 'FontSize', 16, 'Interpreter', 'latex');
                    step = steps(end);
                    lambda = POST.STEP(step).lambda;

                    hold on;
                    axis equal;
                    grid on;
                    view(3);  % Set the view to 3D
                    title(sprintf('$\\lambda = %.2f$', lambda), 'FontSize', 12, 'Interpreter', 'latex');
                    xlabel('X [mm]', 'FontSize', 12, 'Interpreter', 'latex')
                    ylabel('Y [mm]', 'FontSize', 12, 'Interpreter', 'latex')
                    zlabel('Z [mm]', 'FontSize', 12, 'Interpreter', 'latex')

                    % Loop over all elements
                    for k = 1 : MODEL.nels
                        % Get original coordinates (undeformed shape)
                        X = POST.STEP(step).X(k, :);  % X-coordinates
                        Y = POST.STEP(step).Y(k, :);  % Y-coordinates
                        Z = POST.STEP(step).Z(k, :);  % Z-coordinates (3D addition)

                        % Get displacement components
                        x = POST.STEP(step).x(k, :);
                        y = POST.STEP(step).y(k, :);
                        z = POST.STEP(step).z(k, :);  % Displacement in Z-direction (3D addition)

                        % Vertices for undeformed and deformed shapes
                        vert_undeformed = [X; Y; Z].';
                        vert_deformed = [x; y; z].';

                        for kk = 1 : nfaces

                            face = faces(kk, :);

                            % --- Plot deformed shape (solid black edges) ---
                            patch('Vertices', vert_deformed, 'Faces', face, ...
                                'FaceColor', 'w', ...        % No face color
                                'EdgeColor', 'r', ...           % Solid black edges
                                'LineWidth', 1.5);

                            % --- Plot undeformed shape (transparent edges) ---
                            patch('Vertices', vert_undeformed, 'Faces', face, ...
                                'FaceColor', 'w', ...        % No face color
                                'EdgeColor', [0, 0, 0], ...     % Black edges
                                'LineWidth', 1, ...
                                'EdgeAlpha', 0.3);              % Transparent edges


                        end

                    end
                    view(25, 30)

                figure;
                sgtitle('Total Displacement [mm]', 'FontSize', 16, 'Interpreter', 'latex')

                    step = steps(end);
                    lambda = POST.STEP(step).lambda;
                    hold on;
                    axis equal;
                    grid on;
                    title(sprintf('$\\lambda$ = %.2f', lambda), 'FontSize', 12, 'Interpreter', 'latex');
                    xlabel('X [mm]', 'FontSize', 12, 'Interpreter', 'latex')
                    ylabel('Y [mm]', 'FontSize', 12, 'Interpreter', 'latex')
                    zlabel('Z [mm]', 'FontSize', 12, 'Interpreter', 'latex')



                    % Loop over all elements to visualize the displacement for each element
                    for k = 1 : MODEL.nels

                       % Get displacement components
                        x = POST.STEP(step).x(k, :);
                        y = POST.STEP(step).y(k, :);
                        z = POST.STEP(step).z(k, :);  % Displacement in Z-direction (3D addition)

                        % Calculate the total displacement magnitude for color-coding
                        U_tot = POST.STEP(step).U_tot(k, :);

                        vert_deformed = [x; y; z].';

                        for kk = 1 : nfaces

                            face = faces(kk, :);

                            % --- Plot deformed shape (solid black edges) ---
                            patch('Vertices', vert_deformed, 'Faces', face, ...
                                'FaceVertexCData', U_tot.', ...
                                'facecolor', 'interp', ...
                                'EdgeColor', 'k', ...           % Solid black edges
                                'LineWidth', 1);

                        end
                    end

                    hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(step).U_tot)), max(max(POST.STEP(step).U_tot)), 5));
                    hcb.FontSize = 15;
                    colormap(POST.cmap)
                    set(hcb, 'TickLabelInterpreter', 'latex');
                    clim([min(min(POST.STEP(step).U_tot)) max(max(POST.STEP(step).U_tot))])  % Set color limits based on displacement range
                    view(25, 15)

                                    figure;
                sgtitle('Von Mises Stress [MPa]', 'FontSize', 16, 'Interpreter', 'latex')

                    step = steps(end);
                    lambda = POST.STEP(step).lambda;
                    hold on;
                    axis equal;
                    grid on;
                    title(sprintf('$\\lambda$ = %.2f', lambda), 'FontSize', 12, 'Interpreter', 'latex');
                    xlabel('X [mm]', 'FontSize', 12, 'Interpreter', 'latex')
                    ylabel('Y [mm]', 'FontSize', 12, 'Interpreter', 'latex')
                    zlabel('Z [mm]', 'FontSize', 12, 'Interpreter', 'latex')



                    % Loop over all elements to visualize the displacement for each element
                    for k = 1 : MODEL.nels

                       % Get displacement components
                        x = POST.STEP(step).x(k, :);
                        y = POST.STEP(step).y(k, :);
                        z = POST.STEP(step).z(k, :);  % Displacement in Z-direction (3D addition)

                        % Calculate the total displacement magnitude for color-coding
                        sigma_vm = POST.STEP(step).sigmavm_nod(k, :);

                        vert_deformed = [x; y; z].';

                        for kk = 1 : nfaces

                            face = faces(kk, :);

                            % --- Plot deformed shape (solid black edges) ---
                            patch('Vertices', vert_deformed, 'Faces', face, ...
                                'FaceVertexCData', sigma_vm.', ...
                                'facecolor', 'interp', ...
                                'EdgeColor', 'k', ...           % Solid black edges
                                'LineWidth', 1);

                        end
                    end

                    hcb = colorbar('eastoutside', 'Ticks', linspace(min(min(POST.STEP(step).sigmavm_nod)), max(max(POST.STEP(step).sigmavm_nod)), 5));
                    hcb.FontSize = 15;
                    colormap(POST.cmap)
                    set(hcb, 'TickLabelInterpreter', 'latex');
                    clim([min(min(POST.STEP(step).sigmavm_nod)) max(max(POST.STEP(step).sigmavm_nod))])  % Set color limits based on displacement range
                    view(25, 15)

        end

end

