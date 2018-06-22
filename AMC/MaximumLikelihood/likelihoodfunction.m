function likelihood = likelihoodfunction(signal,alphabet,sigma)


% tlikelihood = zeros(numel(signal),1);

M = numel(alphabet);
likelihood = 0;

for iSignal = 1:numel(signal)
%     iLikelihood = zeros(numel(alphabet),1);
    x = ones(1,M) * signal(iSignal);
    likelihood = likelihood + log( mean( exp(-1 * abs(x-alphabet).^2/(2*sigma^2)) / (2 * pi * sigma^2) ) );
    
%     for iAlphabet = 1:numel(alphabet)
%         iLikelihood(iAlphabet) = exp(-(abs(signal(iSignal)-alphabet(iAlphabet)))^2/2/sigma^2)/(2*pi*sigma^2);
%     end
%     tlikelihood(iSignal) = mean(iLikelihood);
end

% likelihood = sum(log(tlikelihood));