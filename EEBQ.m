function [output]=EEBQ(x,n)

% Function name : EEBQ : 
% Finds the location of the pure endmember from the data 
%
% Reference: 
% D. Shah and T. Zaveri, "Hyperspectral Endmember Extraction using Band Quality," 2019 IEEE 16th India Council International Conference (INDICON), Rajkot, India, 2019, pp. 1-4.
%
% Inputs: x  -- A 3D array of data. 
%			    The first dimension is height of hyperspectral data.
%			    The second dimension is length of hyperspectral data.
%               The third dimension is number of bands.    
%         n  -- The number of pure endmembers (hyperspectral subspace dimension)
%
% Output: output -- Location of n number of pure endmembers.

Y = hyperConvert2d(x);
[channels,num] = size(Y);

%%% Step-A : Band selection based on band quality %%%
for k=1:channels
    bri(k)=brisque(x(:,:,k));
end
[q1,q2]=min(bri);
bri(q2)=[];
[q3,q4]=min(bri);
if (q4>q2)
    q4=q4+1;
end
n_y1=q2;
n_x1=q4;
band_x1=Y(n_x1,:)';
band_y1=Y(n_y1,:)';
p11=[band_x1,band_y1];

%%% Step-B : Material identification using convex set %%%
for i=0:0.001:1
    points = boundary(p11,i);
    [m1,n1]=size(points);
    if(m1>n)
        break
    end
end
output=points;

%%% Step-C : Extra pixel removal %%%
z=(size(output)-1);
for i=1:z(1)
    [t1]=p11(output(i),:);
    [t2]=p11(output(i+1),:);
    ED(i,1)=sqrt(sum((t1-t2).^2));
end
e=[p11(output),p11(output,2)];
e(end,:)=[];
output(end,:)=[];
for k=1:1:(m1-n-1)
    [d1,d2]=min(ED);
    e(d2,:)=[];
    ED(d2,:)=[];
    output(d2,:)=[];
end

end