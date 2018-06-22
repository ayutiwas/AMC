clc
clear

load('../MaximumLikelihood/max_lh_result.mat');
result_ml= result;
clear result;

load('../KNN/ML_knn_result');
result_knn = result;
clear result;


addpath('../../');
import param_vals.*;

sym_len = param_vals.symbol_no;
mod_type = param_vals.mod_type;
snr = param_vals.snr;
tr_data_no = param_vals.training_data_no;


% tr_data_no = [100 1000 10000];
% sym_len = [100 1000];
% mod_type = [4 8 16 32 64];
% snr = 0:5:40;

for tr = 1 : length(tr_data_no)
    for s_no = 1 : length(sym_len)
        for mod_no = 1: length(mod_type)
            for snr_no = 1 : length(snr)
                time_ml(snr_no) = result_ml.sumbol_(s_no).mod(mod_no).snr(snr_no).time;  
                time_knn(snr_no) = result_knn.tr_len(tr).sym_len(s_no).mod_type(mod_no).snr(snr_no).time;
            end
            time_ml_mod(mod_no) = mean(time_ml);
            time_knn_mod(mod_no) = mean(time_knn);
        end
        time_ml_sym(s_no) = mean(time_ml_mod);
        time_knn_sym(s_no) = mean(time_knn_mod);
    end
end

fig = figure;
bar_plot = [time_ml_sym(1:2);time_knn_sym(1:2)];
b = bar(bar_plot);%,'r');
%b(2).FaceColor = 'b';
%b(2).EdgeColor = 'b';
legend('100 samples','1000 Samples');
legend('Location','northwest');
set(gca,'xticklabel',{'Max. Likelihood','KNN'});
ylabel('Time(s)');
set(gca,'fontsize', 22);
saveas(fig,strcat('amc_time.eps'),'epsc');

                
                
                
                
                
                
                