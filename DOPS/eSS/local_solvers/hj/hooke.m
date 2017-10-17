% $Header: svn://.../trunk/AMIGO2R2016/Kernel/OPT_solvers/eSS/local_solvers/hj/hooke.m 770 2013-08-06 09:41:45Z attila $
function [x, histout] = hooke(x0, f, budget, tol,iterprint,varargin)
%
% Hooke-Jeeves optimization
%
% C. T. Kelley, July 10, 1998
%
%
% This code comes with no guarantee or warranty of any kind.
%
% function [x, histout] = hooke(x0, f, budget, scales, tol, v)
%
% inputs:
%
%       x0= initial iterate 
%       f = objective function 
%       budget = max f evals (default=50*number of variables)
%                 The iteration will terminate after the iteration that
%                 exhausts the budget
%       scales = the decreasing sequence of stencil sizes
%                 This is an optional argument and the default is
%                 1, 1/2, ... 1/128
%       tol = termination tolerance 
%            difference is function values at successive iterations
%            (default = 1.d-6)
%       v = matrix of search directions (default $v = I$)
%       target = value of f at which the iteration should be terminated
%             This is an optional argument, which you SHOULD set to
%             something reasonable for your problem. The default is
%             as close to no limit as we can get, -1.d8
%
%
% outputs:
%
%        final results = x
%        iteration histor = histout itout x 5
%        histout = iteration history, updated after each nonlinear iteration
%                 = lhist x 2 array, the rows are
%                   [fcount, fval, sval]
%                   fcount = cumulative function evals
%                   fval = current best function value
%                   sval = current scale
%
% set debug = 1 to print iteration stats
%
debug=0;
%
%
n=length(x0); fcount=0; bud=50*n; scal=-(3:30)'; scal=2.^scal; dir=eye(n);
tolf=1.d-9; targ=-1.d8;

%
% cache control paramters
%
global cache_size cache cache_ptr cache_fvals
cache_size=4*n; cache=zeros(n,cache_size); cache_ptr=0;
cache_fvals=zeros(cache_size,1);
%
% count the incoming arguments
%
% if nargin > 2 bud=budget; end
% if nargin > 3 scal=scales; end
% if nargin > 4 tolf=tol; end
% if nargin > 5 targ=target; end
% if nargin > 6 targ=target; end
% if nargin > 7 dir = v; end

bud=budget;
tolf=tol;
%
% main loop to sweep the scales
%
fcount=1; h=scal(1); fv=geval(f,x0,varargin{:}); 
histout=[fcount,fv,h];
fbest=fv;
x=x0; nscal=length(scal); ns=0; 
while (ns < nscal & fcount <= bud)
    ns=ns+1; 
    [x, sf, lhist, fcount] = hjsearch(x, f, scal(ns),dir, fcount,bud,varargin{:});
    histout=[histout',lhist']'; 
    if iterprint
        fprintf('%s %i %s %g \n','Nevals:', histout(end,1), 'Fobj:',histout(end,2))
    end
%
% end main loop
%
end
%
% Search with a single scale
%
function [x, sf, lhist, finc] = hjsearch(xb, f, h,dir, fcount,bud,varargin)
x=xb; xc=x; sf=0; finc=fcount; lhist=[];
[x, fv, sf, numf] = hjexplore(xb, xc, f, h, dir,[], varargin{:});
finc=finc+numf;
if sf==1 thist=[finc, fv, h]; lhist=[lhist',thist']'; end
while sf==1 & finc < bud
%
% pattern move
%
    d=x-xb; xb=x; xc=x+d; fb=fv;
    [x, fv, sf, numf] = hjexplore(xb, xc, f, h, dir,fb,varargin{:});
    finc=finc+numf; 
    if sf == 0 % pattern move fails!
       [x, fv, sf, numf] = hjexplore(xb, xb, f, h, dir, fb,varargin{:});
       finc=finc+numf; 
    end
    if sf==1 thist=[finc, fv, h]; lhist=[lhist',thist']'; end
end
%
% exploratory move
%
function [x, fv, sf, numf] = hjexplore(xb, xc, f, h, dir, fbold,varargin);
global cache_size cache cache_ptr cache_fvals
n=length(xb); x=xb; numf=0;
%if nargin == 5
if isempty(fbold)
    [fb,ctr]=geval(f,x,varargin{:});
    numf=numf+ctr;
else
    fb=fbold;
end
fv=fb;
xt=xc; sf=0; dirh=h*dir;
fvold=fv;
for k=1:n
    p=xt+dirh(:,k); ft=feval(f,p,varargin{:}); numf=numf+1;
    if(ft >= fb) p=xt-dirh(:,k); [ft,ctr]=geval(f,p,varargin{:}); numf=numf+ctr; end
    if(ft < fb) sf=1; xt=p; fb=ft; end
end
if sf==1 x=xt; fv=fb; end
%
%
function [fs,ctr]=geval(fh,xh,varargin)
global cache_size cache cache_ptr cache_fvals
for i=1:cache_size
    nz(i)=norm(xh-cache(:,i));
end
[vz,iz]=min(nz);
if vz == 0 & cache_ptr ~=0
    fs=cache_fvals(iz);
    ctr=0;
else
    fs=feval(fh,xh,varargin{:});
    ctr=1;
    cache_ptr=mod(cache_ptr,cache_size)+1;
    cache(:,cache_ptr)=xh;
    cache_fvals(cache_ptr)=fs;
end

