clc
clear
load('../KNN/ML_knn_result.mat');
% tr_data_no = [100 1000 10000];
% sym_len = [100 1000];
% mod_type = [4 8 16 32];
% snr = 0:5:40;

addpath('../../');
import param_vals.*;

sym_len = param_vals.symbol_no;
mod_type = param_vals.mod_type;
snr = param_vals.snr;
tr_data_no = param_vals.training_data_no;

for tr = 1 : length(tr_data_no)
    for s_no = 1 : length(sym_len)
        for snr_no = 1: length(snr)
            for mod_no = 1 : length(mod_type)
                data(mod_no,:) = cell2mat(result.tr_len(tr).sym_len(s_no).mod_type(mod_no).snr(snr_no).data);
                data_plot(mod_no) = data(mod_no,mod_no);
            end
            data_snr(snr_no,:) = data_plot;
        end
        f = figure;
        plot(snr,data_snr','--o','LineWidth',4,'Markersize',10);
        axis([0 max(snr) 0 100]);
        set(gca,'fontsize',18);
        legend('4-QAM','8-QAM','16-QAM','32-QAM','64-QAM');
        legend('boxoff');
        legend('Location','southeast');
%         title(sprintf('KNN based Classifier''s Classification Accuracy \n %d Training Data, %d Test Data',tr_data_no(tr),sym_len(s_no)));
        saveas(f,strcat('fig_tr',int2str(tr_data_no(tr)),'_sym',int2str(sym_len(s_no)),'.eps'),'epsc');
    end
end

