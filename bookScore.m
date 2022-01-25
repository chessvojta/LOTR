function score = bookScore(rating,reads,type)
%bookScore Calculate score of a book based on its rating and reads
if ~exist('type','var') 
      type = 0;
end

% Type 0 - default
% can be calculated for individual books
% importance of reads increases with increasing number of ratings
if type == 0
    score = rating.*log10(reads);
    
% Type 1
% normalized so that max(score) = 10
% depends on the set of books
elseif type == 1
    normalizedReads = 10.*(reads./max(reads)); % max = 10
    score = (rating+normalizedReads)./2;
    
% Type 2
% normalized so that max(score) = 10
% depends on the set of books
% log scale - increases score of less popular books
elseif type == 2
    normalizedReads = 10.*(log10(reads)./max(log10(reads))); % max = 10
    score = (rating+normalizedReads)./2;
    
else
    error('Unknown scoring type')
end
end

