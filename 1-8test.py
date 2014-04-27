import subprocess
import math
import os
import matplotlib.pyplot as pl

p = subprocess.Popen(
    ['racket', '1-8.scm'],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    env=os.environ)

values = []
for i in range(-20, 20):
  v = pow(10, i)
  values.append({"i": i, "answer": math.pow(v, 1.0 / 3.0), "input":v})
  input_line = "%f\n" % pow(10, i)
  p.stdin.write(input_line)

plotdata = {
    "ans1":[],
    "i":[],
    "ans":[],
    }

(out,err) = p.communicate()
lines = out.split("\n")
for i in range(len(values)):
  value = values[i]
  out_line = lines[i]
  ans1 = float(out_line)
  ans = value["answer"]
  plotdata["ans1"].append(ans1 / ans)
  plotdata["i"].append(value["i"])

pl.plot(plotdata["i"], plotdata["ans1"], color="red")
pl.savefig("1-8.png")


