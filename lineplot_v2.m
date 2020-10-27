function lineplot_v2(x, y, split_by, binx, color)
% lineplot_v2(x, y, split_by, binx, color)

% bin if requested
if not(isempty(binx))
    x = x - mod(x, binx) + binx/2;
end

hold on

% remove nan
if isempty(split_by)
    ndx = not(isnan(x)) & not(isnan(y));
else
    ndx = not(isnan(x)) & not(isnan(y)) & not(isnan(split_by));
    split_by = split_by(ndx);
end
x = x(ndx);
y = y(ndx);

% set color
if isempty(color)
    color = 'b';
end

if isempty(split_by)
    
    if sum(mod(x,1)) == 0
        idx = x - min(x) + 1;
        ndx = idx == idx;
    else
        [~, ~, idx] = histcounts(x);
        ndx = not(idx == 0);
    end
        
    xp = accumarray(idx(ndx), x(ndx), [], @(x) nanmean(x));
    yp = accumarray(idx(ndx), y(ndx), [], @(x) nanmean(x));
    ep = accumarray(idx(ndx), y(ndx), [], @(x) nanstd(x)/sqrt(length(x(not(isnan(x))))));
    
    ndx = not(xp == 0 & yp == 0);
    %shadedErrorBar(xp(ndx),yp(ndx),ep(ndx))
    
    X = sortrows([xp(ndx), yp(ndx), ep(ndx)]);
    errorbar(X(:,1), X(:,2), X(:,3), 'LineWidth', 2, 'MarkerSize', 50, 'CapSize',0, 'Color', color)
    scatter(X(:,1), X(:,2), 30, color, 'filled', 'HandleVisibility','off')
    
else
    ss = unique(split_by)';
    
    for s = ss(not(isnan(ss)))
        
        xd = x(split_by == s);
        yd = y(split_by == s);
        
        ndx = not(isnan(xd)) & not(isnan(yd));
        xd = xd(ndx);
        yd = yd(ndx);
        
        if sum(mod(xd,1)) == 0
            idx = xd - min(xd) + 1;
            ndx = idx == idx;
        else
            [~, ~, idx] = histcounts(xd);
            ndx = not(idx == 0);
        end
        
        xp = accumarray(idx(ndx), xd(ndx), [], @(x) nanmean(x));
        yp = accumarray(idx(ndx), yd(ndx), [], @(x) nanmean(x));
        ep = accumarray(idx(ndx), yd(ndx), [], @(x) nanstd(x)/sqrt(length(x(not(isnan(x))))));
        try
            ndx = not(xp == 0 & yp == 0);
            % shadedErrorBar(xp(ndx),yp(ndx),ep(ndx));
            X = sortrows([xp(ndx), yp(ndx), ep(ndx)]);
            errorbar(X(:,1), X(:,2), X(:,3), 'LineWidth', 2, 'MarkerSize', 50, 'CapSize',0, 'Color', color)
            scatter(X(:,1), X(:,2), 30, color, 'filled','HandleVisibility','off')
        end
        
    end
end

end