clc
clear

% training_data_no = [100 1000 10000];
% mod_type = [4 8 16 32 64];
% symbol_no = [100 1000 10000];
% monte_carlo = 25;
% snr_value = 0:5:40;

addpath('../../');
import param_vals.*;

monte_carlo = param_vals.monte_carlo;
symbol_no = param_vals.symbol_no;
mod_type = param_vals.mod_type;
snr_value = param_vals.snr;
training_data_no = param_vals.training_data_no;

cell_compare = {'4-QAM','8-QAM','16-QAM','32-QAM','64-QAM'};

for tr = 1 : numel(training_data_no)
    [training_data, label] = gen_data(training_data_no(tr));
    rng(3000);
    Mdl = fitcknn(training_data,label,'NumNeighbors',11,'Standardize',1);
    
    % KNN has been trained over all SNRs and modulation
    
    for td = 1 : length(symbol_no)
        for mod_no = 1 : length(mod_type)
            for snr = 1:length(snr_value)
                %                 mod_class = zeros(5,1);
                b = tic;
                B = repmat( struct('mod_class', [0 0 0 0 0]), monte_carlo, 1 );
                rng(100);
                fprintf('Training Data: %d\t Test Data: %d\tSNR : %4.2f dB\t Modulation Type : %d-QAM \n',training_data_no(tr), symbol_no(td), snr_value(snr), mod_type(mod_no));

                parfor i = 1:monte_carlo
%                     fprintf('Training Data: %d\t Test Data: %d\tSNR : %d dB\t Monte Carlo Experiment : %d\t Modulation Type : %d-QAM \n',training_data_no(tr), symbol_no(td), snr_value(snr), i,mod_type(mod_no));
                    data_unmodulated  = randi([0 (mod_type(mod_no)-1)],symbol_no(td),1);
                    data = qammod(data_unmodulated,mod_type(mod_no));
                    n_data = awgn(data, snr_value(snr));
                    n_data = n_data/sqrt(mean(abs(n_data).^2));
                    
                    %------------------------KNN Classifiers---------------------------
                    
                    x_pred = [cumulant(real(n_data)) cumulant(imag(n_data))];
                    predicted_value = predict(Mdl,x_pred);
                    [~,idx] = ismember(predicted_value,cell_compare);
                    B(i).mod_class(idx) = B(i).mod_class(idx) + 1;
                end
                mod_class = sum(vertcat(B(:).mod_class));
                per_mod_class = mod_class/monte_carlo * 100;
                result.tr_len(tr).sym_len(td).mod_type(mod_no).snr(snr).data{:} = per_mod_class;
                result.tr_len(tr).sym_len(td).mod_type(mod_no).snr(snr).time = toc(b);
            end
        end
    end
end
save('ML_knn_result.mat','result');
