function [vars] = p2014_data(validate_data, visualize_data)

    if ~exist('validate_data', 'var'), validate_data = true; end;
    if ~exist('visualize_data', 'var'), visualize_data = false; end;


    p2014_table1 = { ...
        'Homo sapiens',           'F', 45, 1250,  0.60, 2.88, 37.52, 8.13
        'Homo sapiens',           'M', 54, 1625,  0.93, 3.43, 27.50, 7.47
        'Gorilla gorilla',        'M', 48, 477.1, 0.68, 2.26, 24.91, 7.55
        'Pan paniscus',           'M', 34, 313.2, 0.48, 1.72, 30.82, 8.56
        'Pan troglodytes',        'M', 31, 407.2, 0.59, 1.96, 27.35, 8.23
        'Pongo Pygmaeus',         'M', 33, 287.0, 0.60, 2.06, 23.88, 6.95
        'Symphalangu syndactylus','F', 17, 106.9, 0.53, 1.80, 19.47, 5.72
        'Cercocebus agills',      'F', 19,  95.3, 0.43, 1.41, 22.86, 7.06
        'Colobus guerezo',        'F', 15,  83.9, 0.52, 2.16, 18.45, 4.42
        'Macaca nemestrina',      'F',  7,  86.1, 0.44, 1.38, 21.70, 6.96
        'Papio hamadryas',        'F', 31, 139.5, 0.53, 1.78, 21.36, 6.34
        'Alouetta caraya',        'M', 21,  55.8, 0.62, 1.80, 13.38, 4.61
        'Pithecia pithecia',      'F',  1,  30.0, 0.52, 1.92, 12.96, 3.53
        'Sanguinus geoffroyi',    'M', 15,  10.5, 0.43, 1.74, 11.18, 2.74
        'Saimiri sciureus',       'F', 27,  19.2, 0.43, 1.20, 13.63, 4.86
    };

    %% Construct outputs
    varnames = who('p2014_*');
    varvals = cellfun(@eval, varnames, 'UniformOutput', false);
    vars = cell2struct(varvals, varnames);
