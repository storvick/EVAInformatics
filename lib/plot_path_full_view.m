%% plot_evelation_path_full_view
% This function take in a set of X, Y coordinate mesh grids, a Z data point to plot the surface, POIs and a path to follow.
% Units should be in latitude longitude decimal formats the same as the input map file.
%
% Inputs
%    X = [X_coordinates, X_coordinates] created with meshgrid from get_map_data()
%    Y = [Y_coordinates, Y_coordinates] created with meshgrid from get_map_data()
%    Z = surface data to plot, X x Y dimensions of floating point value (elevation, slope, cost, etc...)
%    ROIs = [X_coordinates, Y_Coordinates]
%    path = [X_coordinates, Y_Coordinates]
%    color = colormap Name for the surface plot to use. (https://www.mathworks.com/help/matlab/ref/colormap.html)
%    Z_label = string for the Z axis of the surface plot to be labeled with

% Outputs
%    Displays a plot
%    

function plot_path_full_view(X, Y, Z, POIs, path, color, Z_label)
    %% Plot Z Map
    fig = uifigure('Name',strcat("Path Vizualization: ", Z_label));
    g = uigridlayout(fig,[2 3]);
    g.RowHeight = {'1x','fit'};
    g.ColumnWidth = {'1x','fit','1x'};
    
    ax = uiaxes(g);
    ax.Layout.Row = 1;
    ax.Layout.Column = [1 3];

    set(ax,'units','pix');
    hold(ax, 'on' )
    axis(ax, 'tight');
    axis(ax, 'equal');
    h = surf(ax, X, Y, Z);
    set(h,'LineStyle','none');
    colormap(ax, color);
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    title(ax, "Apollo 12 Landing Site")
    xlabel(ax, "Longitude [deg]")
    ylabel(ax, "Latitude [deg]")
    c = colorbar(ax);
    c.Label.String = Z_label;
    c.Label.Rotation = 270;
    c.Label.VerticalAlignment = "bottom";
    view(ax, 2)
    
    %% Plot ROIs
    Z_poi = ones(length(POIs(:, 1)),1);
    Z_poi(:) = 1000000;
    scatter3(ax, POIs(:, 1),   POIs(:, 2), Z_poi, 14, "filled", "black")
    dx = .0002;
    dy = -.0002;
    num_ROIs = length(POIs);
    c = cell(num_ROIs, 1);
    for i = 1:num_ROIs
    	c{i} = num2str(i);
    end
    text(ax, POIs(:, 1)+dx,   POIs(:, 2)+dy, Z_poi, c, 'FontSize',10);
    
    %% Plot Path Between ROIs
    X_pos = path(:,1);
    Y_pos = path(:,2);
    N = length(path);
    Z_pos = ones(N,1);
    Z_pos(:) = 1000000;
    % Setup refreshdata plotting 
    X_path = NaN(N, 1);
    Y_path = NaN(N, 1);
      
    future_path_plot = plot3(ax, X_pos, Y_pos, Z_pos , 'Color', 'blue', 'LineWidth',1);
    future_path_plot.XDataSource = 'X_pos';
    future_path_plot.YDataSource = 'Y_pos';
    
    pathColor = [.4 .4 .4];
    path_plot = plot3(ax, X_path ,Y_path,Z_pos, 'Color', pathColor, 'LineWidth',2);
    path_plot.XDataSource = 'X_path';
    path_plot.YDataSource = 'Y_path';

    X_current = X_pos(1);
    Y_current = Y_pos(1);
    current_pos = scatter3(ax, X_current,Y_current, 1000000, 'filled', 'blue');
    current_pos.XDataSource = 'X_current';
    current_pos.YDataSource = 'Y_current';
    
    b = uibutton(g, ...
        "Text","Plot Data", ...
        "ButtonPushedFcn", @(src,event) plotButtonPushed(ax, path, path_plot, future_path_plot, current_pos));
    b.Layout.Row = 2;
    b.Layout.Column = 2;
    
    hold(ax, 'off' )
end

function plotButtonPushed(ax, path, path_plot, future_path_plot, current_pos)  
    X_pos = path(:,1);
    Y_pos = path(:,2);
    N = length(path);
    
    X_path = NaN(N, 1);
    Y_path = NaN(N, 1);

    X_current = X_pos(1);
    Y_current = Y_pos(1);

    for i = 1:N
        X_path(i) = X_pos(i);
        Y_path(i) = Y_pos(i);
        X_current = X_pos(i);
        Y_current = Y_pos(i);
        X_pos(i) = NaN;
        Y_pos(i) = NaN;

        refreshdata(path_plot, 'caller')
        refreshdata(future_path_plot, 'caller')
        refreshdata(current_pos, 'caller')
        drawnow
        
    end
end