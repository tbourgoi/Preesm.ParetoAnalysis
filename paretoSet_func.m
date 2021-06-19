function indPar=paretoSet_func(sln)
%PARETOQS   Find Pareto optimal front using modified quicksort
%   indPar=paretoQS(sln) returns row indices to the pareto optimal set of 
%   designs, so that for each point x_i in the front no point x_j performs 
%   better (<) in all objective functions. By definition, duplicates do not
%   dominate each other. Note that all objectives are treated as 
%   minimization, so maximize objectives y_max should be passed as
%                       y_min = -y_max; 
%                             or
%                       y_min = 1/y_max;
%
%   Inputs: sln - The solution space to identify pareto optimal designs in,
%                 as a matrix of the shape nPt x nOf
%                 (number of points x number of objectives) 
%
%   Outputs: indPar - Indices of the pareto optimal points of the given
%                     input space
%
%   Example: 
%       nPt=1000;
%       x=linspace(1/5,5,nPt).';
%       paretoQS([x+0.75.*randn(nPt,1),1./x+0.75.*randn(nPt,1)])
%Asset correct shape
assert(ismatrix(sln),'Input must be an nPt x nOF matrix');
%Find size of sln space
[nPt,nOF]=size(sln);
%Special cases
if isempty(sln)
    %Either/Both dimensions empty, return empty of same 'shape'
    indPar=sln;
    return
elseif nPt==1
    %Only one point must be pareto optimal
    indPar=1;
    return
elseif nOF==1
    %Only one OF, minimum must be the pareto optimal
    [~,indPar]=min(sln);
    return
end
%Init the pareto set to full
indPar=ones(nPt,1);


%Begin iteration
for idx = 1:nPt
    for j = 1:nPt
       if (j ~= idx) && (all(sln(j,:) <= sln(idx,:))) && (any(sln(j,:) < sln(idx,:)))
            indPar(idx) = 0;
            break;
       end
    end
end


