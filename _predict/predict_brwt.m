function brwt = predict_brwt(bvol)
% Predict brain weight from volume, very roughly, using
%   rilling & insel primate volumes and a UW webpage with brain weights
%   for the same species

    global g_wt;

    if isempty(g_wt)
        %% Convert weights to volumes
        wts = [1350 420 500 370 92 22]'; % http://faculty.washington.edu/chudler/facts.html
        vols = [1298 337 383 407 79 23]'; %rilling & insel, 1999
        [p_wt, g_wt, rsq] = allometric_regression(vols, wts);
        fprintf('Brain weight (mixed data): %5.3f * bvol^%5.3f, r^2=%5.3f\n', 10.^p_wt(2), p_wt(1), rsq{1});

    end;

    brwt = g_wt.y(bvol);
