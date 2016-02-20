import math, sys
tab_h=1.0
tab_w=1;
tabs=[];
for tab in range(0, 5):
    if(tab%2==0):
       tabs.append([tab*tab_w, 0 ])
       tabs.append([tab*tab_w+tab_w, 0])
    else:
       tabs.append([tab*tab_w, tab_h])
       tabs.append([tab*tab_w+tab_w,tab_h])


tabs.pop()

for p in tabs:
  x = p[0]
  y = p[1]
  print('[tab_width * %s, skid_height + %s * thickness], ' % (x, y)),

curve=[];
for p in range(0,15):
    x=p/15.0;
    y=  0.466721*(x**3) - 1.28895*(x**2) + 1.64205*x + 0.18055
    curve.append([x*150.0,y*100.0])

#print curve


