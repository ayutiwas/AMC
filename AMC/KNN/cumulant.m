function [c] = cumulant(sig)

    sig = sig-mean(sig);
    sig = sig./std(sig);

    % Calculating signal moments

    M20 = mean(sig.^2);
    M21 = mean(sig.*conj(sig));
    M22 = mean(conj(sig).^2);
    M40 = mean(sig.^4);
    M41 = mean(sig.^3.*conj(sig));
    M42 = mean(sig.^2.*conj(sig).^2);
    M43 = mean(sig.*conj(sig).^3);
    M60 = mean(sig.^6);
    M61 = mean(sig.^5.*conj(sig));
    M62 = mean(sig.^4.*conj(sig).^2);
    M63 = mean(sig.^3.*conj(sig).^3);

    %Calculating Cumulants

    C40 = M40 - 3*M20^2;
    C41 = M41 - 3*M20*M21;
    C42 = M42 - abs(M20)^2 - 2*M21^2;
    C60 = M60 - 15*M20*M40 + 30*M20^3;
    C61 = M61 - 5*M21*M40 - 10*M20*M41 + 30*M20^2*M21; 
    C62 = M62 - 6*M20*M42 - 8*M21*M41 - M22*M40 + 6*M20^2*M22 + 24*M21^2*M20;
    C63 = M63 - 9*M21*M42 + 12*M21^3 - 3*M20*M43 - 3*M22*M41 + 18*M20*M21*M22; 
    
    m = [M20 M21 M22 M40 M41 M42 M43 M60 M61 M62 M63];
    c = [C40 C41 C42 C60 C61 C62 C63];

end