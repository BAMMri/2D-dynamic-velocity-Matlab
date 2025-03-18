function datasetOut = std_interpDataset(datasetIn, interpolationFactor)
% datasetOut = interpDataset(datasetIn, interpolationFactor)

timeDim = ndims(datasetIn);
origSize = size(datasetIn);
newSize = origSize;
newSize(timeDim) = origSize(timeDim)*interpolationFactor;

datasetIn = reshape(datasetIn, [], origSize(timeDim)); % make it a column
datasetOut = zeros(size(datasetIn, 1), size(datasetIn, 2)*interpolationFactor);

for i=1:size(datasetIn,1)
    if all(datasetIn(i,:) == 0)
        continue
    end
    datasetOut(i,:) = interp(datasetIn(i,:), interpolationFactor);
end

datasetOut = reshape(datasetOut, newSize);