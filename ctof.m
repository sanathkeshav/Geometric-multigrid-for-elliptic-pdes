function u = ctof( uc )

[nx,ny] = size( uc );
nxf = 2*(nx-1)+1;
nyf = 2*(nx-1)+1;
u = zeros(nxf,nyf);

% transfer by copying where the grids line up
for j=1:ny
  for i=1:nx
    u(2*(i-1)+1,2*(j-1)+1) = uc(i,j);
  end
end

% linear interpolation in x
for j=1:2:nyf
  for i=2:2:nxf-1
    u(i,j) = 0.5*(u(i-1,j) + u(i+1,j));
  end
end

% linear interpolation in y
for j=2:2:nyf-1
  for i=1:nxf
    u(i,j) = 0.5*(u(i,j-1) + u(i,j+1));
  end
end
