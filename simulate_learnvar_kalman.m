

figure
hold on

s_us = [3,10];
c = {[1,0.5,0.5], [0,0,1]};
for iu = 1:length(s_us)
    
    s_u = s_us(iu);
    
    nt = 100;
    ni = 50;
    
    x = nan(nt, ni);
    o = nan(nt, ni);
    x(1,:) = 0;
    
    s_v = 1;
    
    d = nan(nt, ni);
    a = nan(nt, ni);
    m = nan(nt, ni);
    w = nan(nt, ni);
    v = nan(nt, ni);
    u = nan(nt, ni);
    ts = nan(nt, ni);
    
    m(1,:) = 10;
    w(1,:) = 1;
    u(1,:) = 1;
    v(1,:) = s_v.^2;
    ts(1, :) = 1;
    
    for t = 2:nt
        
        ts(t, :) = t;

        x(t,:) = x(t-1,:) + normrnd(0,s_v,1,ni);
        o(t,:) = x(t,:) + normrnd(0,s_u,1,ni);
        
        d(t,:) = o(t,:) - m(t-1,:);
        a(t,:) = (w(t-1,:) + v(t-1,:))./(w(t-1,:) + v(t-1,:) + u(t-1,:));
        m(t,:) = m(t-1,:) + a(t,:).*d(t,:);
        w(t,:) = (1 - a(t,:)).*(w(t-1,:) + v(t-1,:));
        u(t,:) = u(t-1,:) + a(t,:).*(d(t,:).^2 - u(t-1,:));
        v(t,:) = v(t-1,:);
    end
    
    lineplot_v2(ts(:), u(:), [], [], c{iu})
    plot([0,nt], [s_u^2, s_u^2], "LineWidth", 2, "Color", c{iu},'HandleVisibility','off')
    
    
end

ylabel("estimate of unpredictability")
xlabel("trial")
legend("low unpredictability", "high unpredictability")
set(gca, "FontName", "Arial", "FontSize", 15)

saveas(gcf, "tracking_predictability.png")
