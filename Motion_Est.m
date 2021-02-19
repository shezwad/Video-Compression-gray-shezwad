function [motionVect, EScomputations] = Motion_Est(imgP, imgI, mbSize, p)

[row, col] = size(imgI);
vectors = zeros(2,row*col/mbSize^2);
costs = ones(2*p + 1, 2*p +1) * 65537;
computations = 0;
mbCount = 1;

for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        for m = -p : p
            for n = -p : p
                refBlkVer = i + m;
                refBlkHor = j + n; 
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;
                end
                costs(m+p+1,n+p+1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1),imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
            end
        end
        [dx, dy, ~] = minCost(costs);
        vectors(1,mbCount) = dy-p-1; 
        vectors(2,mbCount) = dx-p-1; 
        mbCount = mbCount + 1;
        costs = ones(2*p + 1, 2*p +1) * 65537;
    end
   
end
motionVect = vectors;
EScomputations = computations/(mbCount - 1);
end