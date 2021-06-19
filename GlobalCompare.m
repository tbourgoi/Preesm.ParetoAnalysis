fprintf('Througput : a = %d , b = %d, (a < b) : %d, (a => b) : %d\n', jln(a,3), jln(b,3), jln(a,3)<jln(b,3), jln(a,3)>=jln(b,3))
fprintf('Latency : a = %d , b = %d, a > b : %d, a <= b : %d\n', jln(a,2), jln(b,2), jln(a,2)>jln(b,2), jln(a,2)<=jln(b,2))
fprintf('Power : a = %d , b = %d, a > b : %d, a <= b : %d\n', jln(a,1), jln(b,1), jln(a,1)>jln(b,1), jln(a,1)<=jln(b,1))
fprintf('Memory : a = %d , b = %d, a > b : %d, a <= b : %d\n', jln(a,4), jln(b,4), jln(a,4)>jln(b,4), jln(a,4)<=jln(b,4))