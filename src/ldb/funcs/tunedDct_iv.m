function c=tunedDct_iv(x)
	n2 = 2*length(x);
	y = zeros(1, 4*n2);
	y(2:2:n2) = x(:);
	z = fft(y);
	c = sqrt(4/n2) .* real(z(2:2:n2));

end
