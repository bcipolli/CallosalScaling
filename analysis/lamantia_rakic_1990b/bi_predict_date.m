bi_predict_pctmye;

%                gmpm = @(wt) exp(polyval(pmpm, log(wt)));
%                gmps = @(wt) exp(polyval(pmps, log(wt), Rmps));
%                gupm = @(wt) exp(polyval(pupm, log(wt), Rupm));
%                gups = @(wt) exp(polyval(pups, log(wt), Rups));
pdns = {'E58' 'P0' 'P4' 'P18' 'P26' 'P39' 'P92' 'P150' 'adult'};

for pi=1:length(pdns)

    pred_date_name = pdns{pi};
    pred_date = datefromtext(pred_date_name, 'cat');

    % Predict parameters, for the given date
    switch w_regress_type
        case 'linear'
            date_m_p = [gmpm(pred_date) gmps(pred_date)];
            date_u_p = [gupm(pred_date) gups(pred_date)];
        case 'linear_mv'
            date_m_p = [gmm(pred_date) gmv(pred_date)];
            date_u_p = [gum(pred_date) guv(pred_date)];

            % back-predict mu and sigma
            date_m_p = [mufn(date_m_p(1), date_m_p(2)) sigmafn(date_m_p(1), date_m_p(2))];
            date_u_p = [mufn(date_u_p(1), date_u_p(2)) sigmafn(date_u_p(1), date_u_p(2))];

        otherwise, error('unknown regress type: %s', w_regress_type);
    end;



    % Show fits for p0
    idx = strcmp(bi_fig9_date_names, pred_date_name);

    pred_pct_mye = gpmye(pred_date)/100;

    xvals = linspace(0, max(bi_fig9_xbins)/2, 100);
    pred_m_distn = pmffn(bi_fig9_xbins, date_m_p(1), date_m_p(2));
    pred_u_distn = pmffn(bi_fig9_xbins, date_u_p(1), date_u_p(2));
    pred_distn   = pred_pct_mye*pred_m_distn + (1-pred_pct_mye)*pred_u_distn;

    if any(idx)
        act_distn    = pred_pct_mye*bi_fig9_myelinated(idx,:) + (1-pred_pct_mye)*bi_fig9_unmyelinated(idx,:);
    else
        act_distn    = zeros(1,size(bi_fig9_myelinated,2));
    end;

    %
    %%    
    % Make a prediction for human data distribution, and compare it to aboitiz et al
    f_abfit = figure;
    pbi = fitfn(act_distn, bi_fig9_xbins)
    %human_m_p = [2.5 3.4];


    f_predict = figure; set(f_predict,'position', [139   297   909   387]);
    subplot(1,2,1);
    bh = bar(xvals, pmffn(xvals, date_u_p(1), date_u_p(2)), 1, 'r', 'EdgeColor','r');
    hold on;
    bar(xvals, pmffn(xvals, date_m_p(1), date_m_p(2)), 1, 'b', 'EdgeColor','b');
    ch = get(bh,'child');
    set(ch,'facea',.5)
    axis tight;%set(gca, 'ylim', [0 0.60], 'xlim', [0 4]);
    legend({'unmyelinated','myelinated'});
    title('Predicted (date) histograms');


    subplot(1,2,2);
    bar(bi_fig9_xbins, act_distn);
    hold on;
    plot(bi_fig9_xbins, pred_distn, 'r--', 'LineWidth', 2);
    plot(bi_fig9_xbins, pmffn(bi_fig9_xbins, pbi(1), pbi(2)), 'g--', 'LineWidth', 2);
    set(gca, 'ylim', [0 0.30], 'xlim', [0 2]);
    legend({'Berbel & Innocenti (1988) data', 'Predicted data', 'Fit to Berbel & Innocenti data'})
    title('Predicted (combined) histograms vs. data');

end;
