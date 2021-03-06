function [gma] = predict_gm_area(brwt, bvol, collation, area_type)
%function [gma] = predict_gm_area(brwt, bvol)
%
% Predict grey matter volume, based on Rilling & Insel (1999a, 1999b)
%
% Fig 2 (Rilling & Insel, 1999a) reported grey matter area
% for the outer surface, not the true surface area.
% Multiply the area (per individual) by the gyrification
% index (per family) to estimate individual grey matter
% surface area.
%
% This had to be determined carefully, indicated by 1999a
% Figure 1.
%
% For grey matter volume, "inner" surface area should be
% used.
%
% Input:
%   brwt: brain weight (g)
%   bvol: [native units] brain volume (cm^3)
%   area_type: inner (default) or outer
%   collation: family, species, individual
%
% Output:
%   gma: grey matter area (cm^2)

    global g_gmas g_gma_collations;

    %collation = 'species';

    if ~exist('bvol','var') || isempty(bvol), bvol = predict_bvol(brwt); end;
    if ~exist('collation','var') || isempty(collation), collation = 'species'; end;
    if ~exist('area_type','var') || isempty(area_type), area_type = 'total'; end;
    if isempty(g_gmas), g_gmas = {}; g_gma_collations = {}; end;

    if ~strcmp(area_type, 'total'), error('Area type "%s" is NYI.', area_type); end;


    if isempty(g_gmas) || ~ismember(collation, g_gma_collations)
        an_dir = fullfile(fileparts(which(mfilename)), '..', 'analysis');

        %
        load(fullfile(an_dir, 'rilling_insel_1999a', 'ria_data.mat'));
        load(fullfile(an_dir, 'rilling_insel_1999b', 'rib_data.mat'));

        %
        [~,famidxa] = ismember(ria_table1_families, rib_families);
        [~,famidxb] = ismember(rib_fig1b_families, rib_families);
        families      = unique(famidxb);
        nfamilies     = length(families);

        switch collation
            case {'family' 'family-i'}
                % We get the GMA from 1999b Fig 2, multiply by GI.
                [~,famidxa] = ismember(ria_table1_families, rib_families);
                [~,famidxb] = ismember(rib_fig1b_families, rib_families);
                bvols = zeros(nfamilies, 1);%size(famidxb));
                gmas = zeros(nfamilies, 1);
                for fi=families
                    idxa = fi==famidxa;
                    idxb = fi==famidxb;
                    bvols(fi) = mean(rib_fig1b_brain_volumes(idxb));
                    gmas(fi) = mean(rib_fig2_gmas(idxb));% .* mean(ria_table6_gi(idxa));  % cm^2
                end;

            case 'species'
                % We get the species volume, then divide by the estimated
                % thickness.
                bvols = rib_table1_brainvol;%rib_fig1b_brain_volumes;
                gmas = ria_table1_gmvol./predict_gm_thickness([], bvols);
                %error('Species computation doesn''t yet use GI');

            case 'individual'
                % We get the GMA from 1999b Fig 2, multiply by GI.
                bvols = rib_fig1b_brain_volumes;  % cm^3

                % Use the family GI
                gis  = zeros(size(rib_fig2_gmas));
                for fi=families
                    gis(famidxb==fi) = mean(ria_table6_gi(famidxa==fi));
                end;

                gmas = rib_fig2_gmas;% .* gis;  % cm^2
        end;
        %gmas(:)'
        %bvols(:)'
        % Now, do the regression
        [p_gma, g_gmas{end+1}, rsq] = allometric_regression(bvols, gmas);
        %allometric_plot2(bvols, gmas, p_gma, g_gmas{end}, {'loglog', 'linear'});

        g_gma_collations{end+1} = collation;
        fprintf('Grey matter surface area (%s) (Rilling & Insel, 1999a/b): %5.3f * bvol^%5.3f, r^2=%5.3f\n', collation, 10.^p_gma(2), p_gma(1), rsq{1});
    end;

    % Now use the functions to compute # cc fibers and # neurons
    gma = g_gmas{strcmp(collation, g_gma_collations)}.y(bvol);
