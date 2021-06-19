% script used to display and compare 2 configurations of the matrix sln

line1 = 5;
line2 = 35;

fprintf('Througput : line1 = %d , line2 = %d, (line1 > line2) : %d, (line1 <= line2) : %d\n', sln(line1,3), sln(line2,3), sln(line1,3)>sln(line2,3), sln(line1,3)<=sln(line2,3))
fprintf('Latency : line1 = %d , line2 = %d, line1 > line2 : %d, line1 <= line2 : %d\n', sln(line1,2), sln(line2,2), sln(line1,2)>sln(line2,2), sln(line1,2)<=sln(line2,2))
fprintf('Power : line1 = %d , line2 = %d, line1 > line2 : %d, line1 <= line2 : %d\n', sln(line1,1), sln(line2,1), sln(line1,1)>sln(line2,1), sln(line1,1)<=sln(line2,1))
fprintf('Memory : line1 = %d , line2 = %d, line1 > line2 : %d, line1 <= line2 : %d\n', sln(line1,4), sln(line2,4), sln(line1,4)>sln(line2,4), sln(line1,4)<=sln(line2,4))