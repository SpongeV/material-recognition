function generateFigures(marginalsSet, material)
%                                                                                                      Eli Broadhurst
%                                                                                                      University of North Carolina at Chapel Hill
%                                                                                                      reb@cs.unc.edu
%
%
%

%When graphing the first two principal modes of variation, this specifies how far out to go in each mode, in units of standard deviation.
amountOut = 1.0;

%Graph settings
graphBins = 100;
minWidth = 0.00000001;
smoothingFactor = 2;

marginals = marginalsSet{material};
numFilters = size(marginals{1}, 1);
numBins    = size(marginals{1}, 2);
numNumbers = length(marginals);

for i = 1:numFilters,
    A = zeros(numNumbers, numBins);
    for j = 1:numNumbers,
        A(j, :) = marginals{j}(i,:);
    end

    %compute mean histogram and first two modes of variation
    bMean = mean(A);
    
    B = A - repmat(bMean, numNumbers, 1);
    [bVectors, bValues] = eig(B'*B);
    bValues = diag(bValues)';
    bValuesCum = cumsum(bValues(end:-1:1)) / sum(bValues);
    bValues = sqrt(bValues(end:-1:1) / (size(B,1)-1));
    bVectors = bVectors(:, end:-1:1);

    %The mean and +- along the first 2 modes
    modes = [];
    modes(1, :) = bMean;
    modes(2, :) = bMean + bVectors(:, 1)' * amountOut * bValues(1);
    modes(3, :) = bMean - bVectors(:, 1)' * amountOut * bValues(1);
    modes(4, :) = bMean + bVectors(:, 2)' * amountOut * bValues(2);
    modes(5, :) = bMean - bVectors(:, 2)' * amountOut * bValues(2);
    A = [A; modes];
    
    %Color code the raw data by their projections onto the first mode
    mode1Levels = sum(B .* repmat(bVectors(:,1)', size(B, 1), 1), 2) / bValues(1);
    mode1Levels = max(0, mode1Levels / max(mode1Levels)) + min(0, - mode1Levels / min(mode1Levels));
    cc = zeros(size(B, 1), 3);
    cc(:, 1) = max(mode1Levels, 0);
    cc(:, 3) = max(-mode1Levels, 0);
    cc(:, 2) = 1 - abs(mode1Levels);
    
    greyCC = zeros(size(B, 1), 3);
    greyCC(:, 1) = max(mode1Levels, 0.1);
    greyCC(:, 3) = max(-mode1Levels, 0.1);
    greyCC(:, 2) = max(1 - abs(mode1Levels), 0.1);
    greyCC = greyCC .^ 0.15;

    myFontSize = 14;
    mySmallFontSize = 14;

    %This returns frequency and position for the pdf histograms
    [nIn, xIn] = getFrequencyHistograms(A, graphBins, minWidth, smoothingFactor);
    xMin = min(xIn);
    xMax = max(xIn);

    modePos = 'r';
    modeNeg = 'b';

    %Each figure will have 6 graphs, the raw data, the mean and 1st mode, and the mean and 2nd mode, displayed
    %both as quantiles and as smooth pdfs estimated from the quantiles
    figure('Position', [100 100 1080 600]);

    ann = annotation('textbox',[0.3 0.0, 0.4, 0.07]);
    set(ann, 'String', ['Material ', num2str(material), ', filter ', num2str(i)], 'fontSize', myFontSize, 'HorizontalAlignment', 'center', 'LineStyle', 'none', 'VerticalAlignment', 'top');

    ticks = [xMin + 0.15 * (xMax - xMin), (xMax+xMin)/2, xMin + 0.85 * (xMax - xMin)];
    tickLabels = {num2str(ticks(1), '%.2f'), num2str(ticks(2), '%.2f'), num2str(ticks(3), '%.2f')};

    %First plot the raw data as pdfs
    subplot(2, 3, 1); hold on;
    title('Training Data', 'fontSize', myFontSize);
    for i = 1:numNumbers,   
        plot(xIn, nIn(i, :), 'color', cc(i, :));
    end

    xlabel('Filter Response', 'fontSize', myFontSize);
    ylabel('Frequency', 'fontSize', myFontSize);
    set(gca, 'xtick', ticks, 'XTickLabel', tickLabels, 'fontSize', mySmallFontSize);
    set(gca, 'ytick', [])
    xDataRange = [xMin, xMax];
    yDataRange = [0, max(max(nIn))];
    xlim(xDataRange);
    ylim(yDataRange);
    hold off;

    %plot raw data as quantials
    subplot(2, 3, 4); hold on;
    for i = 1:numNumbers,    
        plot(1:numBins, A(i, :), 'color', cc(i, :));
    end
    xlabel('p(X < x)', 'fontSize', myFontSize);
    ylabel('Filter Response', 'fontSize', myFontSize);
    set(gca, 'xtick', []);
    set(gca, 'ytick', ticks, 'YTickLabel', tickLabels, 'fontSize', mySmallFontSize);
    xQDataRange = [0, numBins];
    yQDataRange = xDataRange;
    xlim(xQDataRange);
    ylim(yQDataRange);
    hold off;

    %Mean plus first mode as histogram then as quantiles
    subplot(2, 3, 2); hold on;
    title(['1st Mode (', num2str(100 * bValuesCum(1), '%.1f'), '%)'], 'fontSize', myFontSize);

    for i = 1:numNumbers,   
        plot(xIn, nIn(i, :), 'color', greyCC(i, :));
    end
    plot(xIn, nIn(end-4, :), 'color', 'k', 'linewidth', 3);
    plot(xIn, nIn(end-3, :), 'lineStyle', '-', 'color', modePos, 'linewidth', 3);
    plot(xIn, nIn(end-2, :), 'lineStyle', '-', 'color', modeNeg, 'linewidth', 3);
    xlabel('Filter Response', 'fontSize', myFontSize);
    ylabel('Frequency', 'fontSize', myFontSize);
    set(gca, 'xtick', ticks, 'XTickLabel', tickLabels, 'fontSize', mySmallFontSize);
    set(gca, 'ytick', []);
    xlim(xDataRange);
    ylim(yDataRange);
    hold off;

    subplot(2, 3, 5); hold on;
    for i = 1:numNumbers,
        plot(1:numBins, A(i, :), 'color', greyCC(i, :));
    end
    plot(1:numBins, A(end-4, :), 'color', 'k', 'linewidth', 3);
    plot(1:numBins, A(end-3, :), 'lineStyle', '-', 'color', modePos, 'linewidth', 3);
    plot(1:numBins, A(end-2, :), 'lineStyle', '-', 'color', modeNeg, 'linewidth', 3);
    xlabel('p(X < x)', 'fontSize', myFontSize);
    ylabel('Filter Response', 'fontSize', myFontSize);
    set(gca, 'xtick', []);
    set(gca, 'ytick', ticks, 'YTickLabel', tickLabels, 'fontSize', mySmallFontSize);
    xlim(xQDataRange);
    ylim(yQDataRange);
    hold off;

    %Mean plus second mode as histograms then quantiles
    subplot(2, 3, 3); hold on;
    title(['2nd Mode (', num2str(100 * bValuesCum(2), '%.1f'), '%)'], 'fontSize', myFontSize);
    for i = 1:numNumbers,   
        plot(xIn, nIn(i, :), 'color', greyCC(i, :));
    end
    plot(xIn, nIn(end-4, :), 'color', 'k', 'linewidth', 3);
    plot(xIn, nIn(end-1, :), 'lineStyle', '-', 'color', modePos, 'linewidth', 3);
    plot(xIn, nIn(end, :),   'lineStyle', '-', 'color', modeNeg, 'linewidth', 3);
    xlabel('Filter Response', 'fontSize', myFontSize);
    ylabel('Frequency', 'fontSize', myFontSize);
    set(gca, 'xtick', ticks, 'XTickLabel', tickLabels, 'fontSize', mySmallFontSize);
    set(gca, 'ytick', []);
    xlim(xDataRange);
    ylim(yDataRange);
    hold off;

    subplot(2, 3, 6); hold on;
    for i = 1:numNumbers,    
        plot(1:numBins, A(i, :), 'color', greyCC(i, :));
    end
    plot(1:numBins, A(end-4, :), 'color', 'k', 'linewidth', 3);
    plot(1:numBins, A(end-1, :), 'lineStyle', '-', 'color', modePos, 'linewidth', 3);
    plot(1:numBins, A(end, :),   'lineStyle', '-', 'color', modeNeg, 'linewidth', 3);
    xlabel('p(X < x)', 'fontSize', myFontSize);
    ylabel('Filter Response', 'fontSize', myFontSize);
    set(gca, 'xtick', []);
    set(gca, 'ytick', ticks, 'YTickLabel', tickLabels, 'fontSize', mySmallFontSize);
    xlim(xQDataRange);
    ylim(yQDataRange);
    hold off;    
end

