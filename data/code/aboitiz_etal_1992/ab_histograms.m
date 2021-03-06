function vars = ab_histograms(validate_data)
%
% Figures:
%   Figure 4
%

    if ~exist('validate_data', 'var'), validate_data = true; end;
    if ~exist('visualize_data', 'var'), visualize_data = false; end;

    AB_dirpath = fileparts(which(mfilename));
    AB_dirname = guru_fileparts(AB_dirpath, 'name');
    AB_img_dirpath = fullfile(AB_dirpath, '..', '..', 'img', AB_dirname);
    ab_dir = fileparts(which(mfilename));

    %% Collect data

    % Figure 4
    ab_fig4_areas = {'genu' 'ant_midbody' 'midbody' 'post_midbody' 'splenium'};
    ab_fig4_xtick_vals = 1:9;
    ab_fig4_xbin_vals  = 0.2:0.2:9;
    ab_fig4_ytick_vals = 0:5:30;
    ab_fig4_n_yticks = 1+[6 5 5 4 4]; % not all plots have same # yticks
    ab_fig4_rots = [0.25 0 0 0.25 0]; % some plots are rotated :(

    ab_fig4_data = zeros(length(ab_fig4_areas), length(ab_fig4_xbin_vals));
    for ai=1:length(ab_fig4_areas)
        fn = sprintf('aboitiz_etal_1992_fig4_%s.png', ab_fig4_areas{ai});
        ab_fig4_data(ai,:) = process_ab_histogram(fullfile(AB_img_dirpath, fn), ab_fig4_xtick_vals, ab_fig4_ytick_vals(1:ab_fig4_n_yticks(ai)), ab_fig4_rots(ai));
    end;


    %% Do validation
    if validate_data
    end;


    %% Construct outputs
    varnames = who('ab_*');
    varvals = cellfun(@eval, varnames, 'UniformOutput', false);
    vars = cell2struct(varvals, varnames);
