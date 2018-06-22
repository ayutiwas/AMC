function [ training_data, label ] = gen_data( sample_no )

addpath('../../');
import param_vals.*;

monte_carlo = param_vals.monte_carlo;
% symbol_no = param_vals.symbol_no;
% training_data_no = param_vals.training_data_no;
%     monte_carlo = 100;

count = 1;
for mod_type = param_vals.mod_type
    for snr = param_vals.snr
        fprintf('mod_type : %d\t snr: %4.2f\n',mod_type,snr);
        for i = 1 : 100
            data_unmodulated = qammod(randi([0 (mod_type-1)],sample_no,1),mod_type);
            n_data = awgn(data_unmodulated,snr);
            n_data = n_data/sqrt(mean(abs(n_data).^2));
            label(count,:) = cellstr(sprintf('%d-QAM',mod_type));
            training_data(count,:) = [cumulant(real(n_data)) cumulant(imag(n_data))];
            count = count + 1;
        end
    end
end
clc;


end

