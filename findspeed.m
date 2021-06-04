function [speed,speed_pixels] = findspeed(filename)

filename = 'ball.mov';
v= VideoReader(filename);
i=1;
while hasFrame(v)
    frame = readFrame(v);
    filename = [sprintf('ball%03d',i) '.jpg'];
    imwrite(frame,filename);
    i = i+1;
end




for x=1:i-1
    filename = [sprintf('ball%03d',x) '.jpg'];
    X=imread(filename);
    level = graythresh(X);
    BW = im2bw(X,level);
    BW = logical(BW);
    BW=not(BW);
    outfilename = [sprintf('bw_ball%03d',x) '.jpg'];
    imwrite(BW,outfilename);
end

horizontal = [];
vertical = [];
% height = [];


filename = 'bw_ball001.jpg';
X=imread(filename);
X=logical(X);
[rows,columns,dim] = size(X);

 X=not(X);
top = 0;
bottom = 0;


for a=1:rows
    for b=1:columns
        if (X(a,b)==0 && top==0)
            top=a;
        end
        
        if (X(a,b)==0)
            bottom=a;
        end
    end
end

objectheight = bottom-top+1;

scale = 0.24/objectheight;
framerate = v.FrameRate;

for x=1:i-1

inputfile = [sprintf('bw_ball%03d',x) '.jpg'];
I = imread(inputfile);
I=logical(I);

[rows,columns,dim] = size(I);




area = 0;
for r=1:rows
    for c=1:columns
        if I(r,c) == 1
            area = area+1;
        end
    end
end


r1=0;
c1=0;

for r=1:rows
    for c=1:columns
        if I(r,c) == 1
            r1 = r1+r;
        end
    end
end

r1=r1/area;

%horizontal = [horizontal;r1];
horizontal(x) = r1;
for r=1:rows
    for c=1:columns
        if I(r,c) == 1
            c1 = c1+c;
        end
    end
end

c1=c1/area;
%vertical = [vertical;c1];
vertical(x) = c1;
end


displacement =[];

for i=1:(length(vertical)-1)
    difference_x = vertical(i+1)-vertical(i);
    difference_y = horizontal(i+1)-horizontal(i);
    displacement_x(i)=difference_x;
    displacement_y(i)=difference_y;
    displacement(i)=sqrt(difference_x^2+difference_y^2);
end


total_displacement = sqrt((vertical(45)-vertical(1))^2 + (horizontal(45)-horizontal(1))^2);

speed = total_displacement * scale * framerate;
speed_pixels = total_displacement * framerate;