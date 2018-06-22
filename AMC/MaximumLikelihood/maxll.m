clc
clear

addpath('../../');
import param_vals.*;

act_4 = qammod(0:3,4);
act_4 = act_4/sqrt(mean(abs(act_4).^2));

act_8 = qammod(0:7,8);
act_8 = act_8/sqrt(mean(abs(act_8).^2));

act_16 = qammod(0:15,16);
act_16 = act_16/sqrt(mean(abs(act_16).^2));

act_32 = qammod(0:31,32);
act_32 = act_32/sqrt(mean(abs(act_32).^2));

act_64 = qammod(0:63,64);
act_64 = act_64/sqrt(mean(abs(act_64).^2));

monte_carlo = param_vals.monte_carlo;
symbol_no = param_vals.symbol_no;
mod_type = param_vals.mod_type;
snr = param_vals.snr;

result = struct;

% number of symbols per test case
for symbol = 1:numel(symbol_no)
    
    % mod_no is the ground truth
    for mod_no = 1:numel(mod_type)
       
        % different SNRs
        for snr_no = 1 : length(snr)
            sigma = sqrt(10^(-snr(snr_no)/10))/sqrt(2);
            b = tic;
            B = repmat( struct('mll', [0 0 0 0 0]), monte_carlo, 1 );
            
            rng(100);   
            fprintf('Symbol: %d \tSNR : %4.2f dB\t Modulation Type : %d-QAM \n',symbol_no(symbol), snr(snr_no), mod_type(mod_no));

            % average over many runs
            parfor i = 1 : monte_carlo
                data_unmodulated  = randi([0 (mod_type(mod_no)-1)], symbol_no(symbol),1);
%                 fprintf('Symbol: %d \tSNR : %d dB\t , Monte Carlo Experiment : %d\t, Modulation Type : %d-QAM \n',symbol_no(symbol), snr(snr_no), i,mod_type(mod_no));
                data = qammod(data_unmodulated,mod_type(mod_no));
                n_data = awgn(data, snr(snr_no));
                n_data = n_data/sqrt(mean(abs(n_data).^2));
                
                ll = zeros(5,1);
                
                ll(1) = likelihoodfunction(n_data, act_4, sigma);
                ll(2) = likelihoodfunction(n_data, act_8, sigma);
                ll(3) = likelihoodfunction(n_data, act_16, sigma);
                ll(4) = likelihoodfunction(n_data, act_32, sigma);
                ll(5) = likelihoodfunction(n_data, act_64, sigma);
                
                [~,idx] = max(ll);
                B(i).mll(idx) = B(i).mll(idx) + 1;
            end
            
            mll = sum(vertcat(B(:).mll));
            
            per_mll = (mll/monte_carlo)*100;
            result.sumbol_(symbol).mod(mod_no).snr(snr_no).data{:} = per_mll;
            result.sumbol_(symbol).mod(mod_no).snr(snr_no).time = toc(b)/monte_carlo;
        end
    end
end

save('max_lh_result.mat','result');

