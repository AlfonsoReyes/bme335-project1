clc; close all; clear all;
% a is the concentration of A from 0 to 1 in intervals of 0.01
a = linspace(0,1,(1-0)/0.01+1);
% b is the concentration of B from 0 to 1 in intervals of 0.01
b = linspace(0,1,(1-0)/0.01+1);

alp = 11.6;
bet = 5.3;

pdf_1 = []; %pdf matrix of the first equation
pdf_2 = []; %pdf matrix of the second equation
pdf_sum = [];

tot_pdf1 = 0;
tot_pdf2 = 0;

for x = 1:length(a)
    for y = 1: length(b)
        % calculate values of each pdf matrix
        pdf_1(y,x) = alp * ( 0.05 + a(x)^2 ) * ( (b(y)-1)^4 + 0.025 );
        pdf_2(y,x) = bet * ( 1 - a(x)^2 ) * ( 0.05 + b(y)^4 + (a(x)^2) * (b(y)^2) /2 );

        tot_pdf1 = tot_pdf1 + pdf_1(y,x);
        tot_pdf2 = tot_pdf2 + pdf_2(y,x); 
    end
    
end

sum(sum(pdf_1))
sum(sum(pdf_2))

j_pdf1 = pdf_1 ./ tot_pdf1;
j_pdf2 = pdf_2 ./ tot_pdf2;

sum(sum(j_pdf1))
sum(sum(j_pdf2))

%optimal concentrations for A and B
at_opt = 0;
bt_opt = 0;

at_opt_2 = 0;
bt_opt_2 = 0;

q1_sum = 0;
q4_sum = 0;

%initials
j1_q1_min = 1;
j2_q1_max = 0;
j1_q4_max = 0;
j2_q4_min = 1;

sum_j1_q1 = 0;
sum_j2_q1 = 0;
sum_j1_q4 = 0;
sum_j2_q4 = 0;


%first two for loops go through A 0.30 to 0.70 
%and B 0.30 to 0.70 to find optimal concentrations
for at = 30:70
    
for bt = 30:70 
    %reset sums of each JPDF at each quadrant
    sum_j1_q1 = 0;
    sum_j2_q1 = 0;
    sum_j1_q4 = 0;
    sum_j2_q4 = 0;

%quadrant 1 (high B, low A)
for xt = 1:at
    
    for yt= bt:length(b)
       
        sum_j1_q1 = sum_j1_q1 + j_pdf1(yt,xt);
        sum_j2_q1 = sum_j2_q1 + j_pdf2(yt,xt);
       
    end
end

%quadrant 4 (low B, high A)
for xt = at:length(a)
    
    for yt = 1:bt
       
        sum_j1_q4 = sum_j1_q4 + j_pdf1(yt,xt);
        sum_j2_q4 = sum_j2_q4 + j_pdf2(yt,xt);
       
    end
end

%optimization search METHOD 1
if(sum_j1_q1 < 0.1 && sum_j2_q1 > j2_q1_max && sum_j1_q4 > j1_q4_max && sum_j2_q4 < 0.1)
    j1_q1_min = sum_j1_q1;
    j2_q1_max = sum_j2_q1;
    j1_q4_max = sum_j1_q4;
    j2_q4_min = sum_j2_q4;
    at_opt = at;
    bt_opt = bt;
    fprintf('METHOD 1:new optimal concentrations found:\n A: %2.0f  B: %2.0f\n\n',at,bt);
end

    %optimization search METHOD 2
    if(sum_j1_q1 + sum_j2_q1 > 0.7 && sum_j1_q4 + sum_j2_q4 > 0.69 && sum_j1_q1 < 0.15 && sum_j2_q4 < 0.15)
    
    fprintf('METHOD 2:new optimal concentrations found: A: %2.0f B: %2.0f\n',at,bt);
    disp(sum_j1_q1)%sum of T1 JPDFs within Q1
    disp(sum_j2_q1)%sum of T2 JPDFs within Q1
    disp(sum_j1_q4)%sum of T1 JPDFs within Q4
    disp(sum_j2_q4)%sum of T2 JPDFs within Q4
    
    end

end

end

%print out results from optimization using method 1
fprintf('method one\n');
fprintf('optimal [A] and [B]\n');
disp(at_opt/100);
disp(bt_opt/100);
fprintf('quadrant 1\n');
disp(j1_q1_min)
disp(j2_q1_max)
fprintf('quadrant 4\n');
disp(j1_q4_max)
disp(j2_q4_min)



% 
% %plot first pdf 
% subplot(1,2,1);
% surf(a,b,j_pdf1);
% title('T1 pdf');
% xlabel('a');
% ylabel('b');
% hold on
% %plot second pdf
% subplot(1,2,2);
% surf(a,b,j_pdf2);
% title('T2 pdf');
% xlabel('a');
% ylabel('b');
% hold on
% 


