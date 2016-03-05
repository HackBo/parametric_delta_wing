from naca import naca4


#INCREASE=80

WIDTH=10
POINTS=5000
if True:
  INCREASE=0
  NACA='2410'
  CHORD=830 + INCREASE
  FRONT_DIST=80
else:
  INCREASE=80
  NACA='3412'
  CHORD=165 + INCREASE
  FRONT_DIST=80

def generate_foil():
  ret_x = []
  ret_y = []
  xf, yf = naca4(NACA, POINTS)
  for i in range(len(xf)):
    if abs(yf[i]*CHORD) <  WIDTH / 2 and xf[i] > 0.5:
      continue
    xf[i] *= CHORD
    yf[i] *= CHORD
    ret_x.append(xf[i])
    ret_y.append(yf[i])
  return ret_x, ret_y

def compute_scad():
  x, y = generate_foil()
  first_x = x[0]
  last_x = x[-1]
  x.append(last_x) ; y.append(-WIDTH/2)
  x.append(FRONT_DIST) ; y.append(-WIDTH/2)
  x.append(FRONT_DIST) ; y.append(WIDTH/2)
  x.append(first_x) ; y.append(WIDTH/2)
  return x, y

def generate_openscad():
  x, y = compute_scad()
  polygon_point = []
  for i in range(len(x)):
    polygon_point.append('[{}, {}]'.format(x[i], y[i]))
  print('include <lasercut/lasercut.scad>;')
  print('poly = [' + ','.join(polygon_point) + '];')
  print('lasercutout(thickness={}, points=poly);'.format(5))

generate_openscad()

     
#vert_stab_polygon = concat(skid_leading_curve, concat(skid_tabs, [skidb_p1, skidb_p2, skidb_p3, skidb_p4, skidb_p5, skidb_p6, skidb_p7, skidb_p8, skidb_p9,skidb_p10, skidb_p12]));
