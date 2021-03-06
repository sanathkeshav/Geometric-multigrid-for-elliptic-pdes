clear all;
close all;
format longe;
clc;
errr = zeros(6,1);
hp = zeros(6,1);
N = 16;
for q=1:6
    tol = 1.0e-8;
    ncycles = 10000;

    ax = 0; bx = 1;
    ay = 0; by = 1;
    nx = N+1; h = (bx-ax)/(nx-1);
    ny = nx; by = ay + (ny-1)*h;
    ii = 1:nx; x = ax + (ii-1)*h;
    jj = 1:ny; y = ay + (jj-1)*h;
    [X,Y] = ndgrid(x,y);	
    hp(q) = (bx-ax)/N;

    u = zeros(nx,ny);
    f = zeros(nx,ny);
    uexact = zeros(nx,ny);

    uexact = ufun( X, Y );

    f = ffun( X, Y );


    u(1:nx, 1) = uexact(1:nx, 1);
    u(1:nx,ny) = uexact(1:nx,ny);

    u( 1,1:ny) = uexact( 1,1:ny);
    u(nx,1:ny) = uexact(nx,1:ny);

    n1 = 2; % number of sweeps on downward branch
    n2 = 1; % number of sweeps on upward   branch
    n3 = 10; % number of sweeps on coarsest grid
    fprintf('N = %d \n',N);
    k=0;
    for icycle=2:ncycles+1
        u1 = u;
        [u,k] = mgv( f, u, h, n1, n2, n3 ,k );
            rmax= max(max(abs( resid(f,u,h) )))*h;
            emax= max(max(abs( u-uexact )));
            fprintf('The Maximum difference between exact and approximate solution after cycle %d is %.15f \n', icycle-1,emax);
            err = max(max(abs(u-u1)));
        if err <= tol, break, end;
    end
    errr(q) = emax;
%         figure (1)
%         title('Exact Solution');
%         hold on;
%         surf(x,y,uexact,'EdgeColor','none');
% 
%         figure (2)
%         title('Approximate Solution');
%         hold on;
%         surf(x,y,u,'EdgeColor','none');

    fprintf('The number of iterations are %d \n ',k);
    %fprintf('The maximum difference between approximate and exact solution is %.15f \n',emax);
    fprintf('The maximum value of residual is %.15f \n',rmax);
    N = N*2;
end
for q=1:5
    order(q) = log(errr(q)/errr(q+1))/log(2);
end
order'
hold on;
xlabel('Log(h) \rightarrow');
ylabel('Log(error) \rightarrow');
plot(log(hp),log(errr),'r');
