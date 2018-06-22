classdef param_vals
    %PARAM_VALS Summary of this class goes here
    %   Detailed explanation goes here

    
    properties (Constant)
        monte_carlo = 1000;
        symbol_no = [100 1000];
        mod_type = [4 8 16 32 64];
        snr = 0:0.5:15;
        training_data_no = [100 1000];
        
        pfa = 0.1;
        n_fft = [1024 2048];
        snr_mtx = [0 10 20 30 40];
        numfiles = 100;
        multiscale = 1:3;
    end
    
    methods
        
    end
    
end

