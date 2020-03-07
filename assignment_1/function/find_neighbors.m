function neighbors = find_neighbors(px)
%find_neighbors Helper function to find 4-way connected neighbors of input
%   px
%   INPUT: 
%   px = target pixel coordinates in the form [i j]
%   OUTPUT: 
%   neighbors = matrix of i,j coordinates of 4-way neighbors (8-way
%   commented out)
    i = px(1);
    j = px(2);
    neighbors = [
        % lower row
        [(i + 1) j ];
%         [(i + 1) (j - 1) ];
%         [(i + 1) (j + 1) ];
        % upper row
        [(i - 1) j ];
%         [(i - 1) (j - 1) ];
%         [(i - 1) (j + 1) ];
        % same row
        [i (j + 1 )];
        [i (j - 1 )]
    ];
end

