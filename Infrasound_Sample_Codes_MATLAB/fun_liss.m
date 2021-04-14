function liss = fun_liss(nfft,ncol,no,n_delta)


x=[1:nfft];

liss = zeros(nfft,ncol);

for m = 1:ncol
    liss(:,m) = (cos((x-n_delta(m))*pi/(nfft+1)).^no)';
end

