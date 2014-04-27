import subprocess
import math
import os
import matplotlib.pyplot as pl

p = subprocess.Popen(
    ['racket', '1-7.scm'],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    env=os.environ)

values = []
for i in range(-20, 10):
  v = pow(10, i)
  values.append({"i": i, "answer": math.sqrt(v), "input":v})
  input_line = "%f\n" % pow(10, i)
  p.stdin.write(input_line)

plotdata = {
    "ans1":[],
    "ans2":[],
    "i":[],
    "ans":[],
    }

(out,err) = p.communicate()
lines = out.split("\n")
for i in range(len(values)):
  value = values[i]
  out_line = lines[i]
  (ans1, ans2) = out_line.split(",")
  (ans1, ans2) = (float(ans1), float(ans2))
  ans = value["answer"]
  plotdata["ans1"].append(ans1 / ans)
  plotdata["ans2"].append(ans2 / ans)
  plotdata["i"].append(value["i"])

pl.plot(plotdata["i"], plotdata["ans1"], color="red")
pl.plot(plotdata["i"], plotdata["ans2"], color="blue")
pl.savefig("1-7.png")

