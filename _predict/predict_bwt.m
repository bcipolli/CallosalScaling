function bwt = predict_bwt(bvol)
% Predict brain weight from volume, very roughly, using
%   rilling & insel primate volumes and a UW webpage with brain weights
%   for the same species

    global g_wt;

    if isempty(g_wt)
        %% Convert weights to volumes
        wts = [1350 420 500 370 92 22]'; % http://faculty.washington.edu/chudler/facts.html
        vols = [1298 337 383 407 79 23]'; %rilling & insel, 1999
        [~,g_wt] = allometric_regression(vols, wts);
    end;
    bwt = g_wt.y(bvol);
