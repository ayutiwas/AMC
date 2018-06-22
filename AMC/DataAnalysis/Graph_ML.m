clc
clear
load('../MaximumLikelihood/max_lh_result.mat');
% tr_data_no = [100 1000];
% mod_type = [4 8 16 32 64];
% snr = 0:5:40;

addpath('../../');
import param_vals.*;

tr_data_no = param_vals.symbol_no;
mod_type = param_vals.mod_type;
snr = param_vals.snr;


for tr = 1 : length(tr_data_no)
    for snr_no = 1: length(snr)
        for mod_no = 1 : length(mod_type)
            data(mod_no,:) = cell2mat(result.sumbol_(tr).mod(mod_no).snr(snr_no).data);
            data_plot(mod_no) = data(mod_no,mod_no);
        end
        data_snr(snr_no,:) = data_plot;
    end
    f = figure;
    plot(snr,data_snr','--o','LineWidth',4,'Markersize',10);
    axis([0 max(snr) 0 100]);
    xlabel('SNR (dB)');
    ylabel('Accuracy (%)');
    set(gca,'fontsize',18);
    if tr == 1
        legend('4-QAM','8-QAM','16-QAM','32-QAM','64-QAM');
        %legend('boxoff');
        legend('Location','southeast');
    end
    %title(sprintf('Maximum Likelihood Method \nClassification Accuracy for %d Symbols',tr_data_no(tr)));
    saveas(f,strcat('fig_sym',int2str(tr_data_no(tr)),'.eps'),'epsc');

end

