function microfract

%%%%%%%%%%%%%%%%%%%
%2d crack problem...given two points defining a macro line crack, find the
%most likely crack on the microstructural scale
%    CLASS:: An 1xN vector which specifies the initial labels of each
%      of the N nodes in the graph
%      initial class assignment for this problem will be class=[1 x 3], x is
%      unknown and is taken to be 1
%    UNARY:: A CxN matrix specifying the potentials (data term) for
%      each of the C possible classes at each of the N nodes. This is the
%      penalty term
%    PAIRWISE:: An NxN sparse matrix specifying the graph structure and
%      cost for each link between nodes in the graph. cost is 1 for all
%      links otherwise zero if nodes are not connected
%    LABELCOST:: A CxC matrix specifying the fixed label cost for the
%      labels of each adjacent node in the graph. this is the potential
%      energy p 

IMG = imread('polycrystal.bmp');
imgsz = min(size(IMG,1),size(IMG,2));
IMG = IMG(1:imgsz,1:imgsz,:);%load square image, low value areas are weak, high index strong
imshow(IMG,'InitialMag','fit');


mag = 64/imgsz;
bond = rgb2gray(imresize(IMG, mag));

maxlevels = 4;
bond = double(bond - min(min(bond))) ./ double(max(max(bond))- min(min(bond)));
bond = uint8(bond * maxlevels);

imgsz = imgsz*mag;

Nnodes = imgsz^2;
Nclasses = 2;%Nclasses = 2 implies one center crack
class = ones(1,Nnodes);%initial classes

img = zeros(imgsz);

%define crack line through graphical input
text(0,-5,'click on two points to define the macro-crack line')
[x1,y1] = ginput(2);
x = y1.*mag;
y = x1.*mag;
A = 1; B = -(x(2)-x(1))/(y(2)-y(1));C = -B*y(1) - x(1);


%%%develop unary as a scaled distance from the line
fac = sqrt(A^2 + B^2);
for i = 1:Nnodes
   a  = nodetoindex(i,imgsz);
   dist1(i) = (A*a(1) + B*a(2) + C)/fac;
   mat2(a(1),a(2)) = (sign(dist1(i))+1)/2;
end
[~,I] = find(dist1 >= 0);
zplus = max(abs(dist1(I)));
[~,I] = find(dist1 < 0);
zminus = max(abs(dist1(I)));

unary = zeros(Nclasses,Nnodes);
lambda = maxlevels/2;%controls data term
for i = 1:Nnodes
    if dist1(i) >= 0
        unary(1,i) = round(lambda*abs(dist1(i))/zplus);
    else
        unary(2,i) = round(lambda*abs(dist1(i))/zminus);
    end
end

%pairwise cost: just indicate links by bond strength
pairwise = zeros(Nnodes,Nnodes);
for i = 1:Nnodes
    a  = nodetoindex(i,imgsz);
    for j = (i+1):Nnodes
        b  = nodetoindex(j,imgsz);
        if norm(a-b) == 1
            pairwise(i,j) = (bond(a(1),a(2)) + bond(b(1),b(2)))/2;
        end
    end
end

%smooth cost - 0-0 and 1-1 are weighted zero, 0-1 neighbor is weighted 1
for i = 1:Nclasses
    for j =1:Nclasses
        labelcost(i,j) = ((i-j)^2);
    end
end

h = GCO_Create(Nnodes,Nclasses);             % Create new object with NumSites=4, NumLabels=3
GCO_SetDataCost(h,unary);  
GCO_SetSmoothCost(h,labelcost);    
GCO_SetNeighbors(h,pairwise);
GCO_Expansion(h);                % Compute optimal labeling via swap 
disp = GCO_GetLabeling(h);
[E D S] = GCO_ComputeEnergy(h);   % Energy = Data Energy + Smooth Energy
GCO_Delete(h);                   % Delete the GCoptimization object when finished

for n = 1:Nnodes
    a = nodetoindex(n,imgsz);
mat(a(1),a(2)) = disp(n);
end

hold on
[B,L] = bwboundaries(mat-1,'noholes');
hold on
for k = 1:length(B)
    boundary = B{k}./mag;
    plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 3)
end
hold on
[B,L] = bwboundaries(mat2,'noholes');
hold on
for k = 1:length(B)
    boundary = B{k}./mag;
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
text(0,(imgsz/mag)+5,'Green line: Microcrack, white line: Macro crack line input')

function a  = nodetoindex(n,imgsz)
a(2) = rem(n,imgsz);

if a(2) == 0
a(1) = floor(n/imgsz);
else
a(1) = floor(n/imgsz)+1;
end

if a(2) == 0
    a(2) = imgsz;
end






