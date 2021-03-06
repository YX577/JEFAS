function [M_psi,M_tmpdpsi] = bas_calc_dcov(scales,wav_typ,wav_param,T)
% BAS_CALC_DCOV Computation of the part of the covariance and its derivative
% which are independent of theta
% usage:	[M_psi,M_tmpdpsi] = bas_calc_dcov(scales,wav_typ,wav_param,T)
%
% Input:
%   scales: vector of scales where the CWT is calculated
%   wav_typ: type of wavelet
% 	wav_param: cf. cwt_JEFAS
%   T: length of the frequency vector
% 
% Output:
%   M_psi: matrix necessary for covariance matrix computation
%   M_tmpdpsi: matrix necessary for covariance matrix computation

% Copyright (C) 2017 Adrien MEYNARD
% 
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% Author: Adrien MEYNARD
% Created: 2017-12-19

omega = (0:(T-1))*2*pi/T;

scales = scales(:);
M_tmp = scales*omega;

switch wav_typ
    case 'sharp'
        par = -2*wav_param;
        M_ftmp1 = (pi./(2*M_tmp+eps));
        M_ftmp2 = (2*M_tmp/pi);
        M_psi = exp( par*(M_ftmp1 + M_ftmp2 - 2) );
        M_tmpdpsi = par*( M_ftmp2 - M_ftmp1 ).*M_psi;
        
    case 'dgauss'
        Cst = 4*wav_param/(pi^2);
        K = (2/pi)^wav_param*exp(wav_param/2);
        M_tmp_pow = M_tmp.^wav_param;
        M_psi = K * M_tmp_pow.* exp(-Cst*M_tmp.^2/2);
        M_tmpdpsi = (wav_param - Cst*M_tmp.^2).*M_psi;
end

M_psi = bsxfun(@times,sqrt(scales),M_psi);
M_tmpdpsi = bsxfun(@times,sqrt(scales),M_tmpdpsi);

end