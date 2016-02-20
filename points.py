import math, sys
skid_h=105;
tab_h=5.0
tab_w=50.0;
tabs=[];
for tab in range(0,10):
    if(tab%2==0):
       tabs.append([tab*tab_w, 0+skid_h ])
       tabs.append([tab*tab_w+tab_w, 0+skid_h ])
    else:
       tabs.append([tab*tab_w, tab_h +skid_h])
       tabs.append([tab*tab_w+tab_w,tab_h +skid_h ])


print tabs

curve=[];
for p in range(0,15):
    x=p/15.0;
    y=  0.466721*(x**3) - 1.28895*(x**2) + 1.64205*x + 0.18055
    curve.append([x*150.0,y*100.0])

#print curve


