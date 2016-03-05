from naca import naca4

INCREASE=80

POINTS=500
NACA='2412'
WIDTH=10
CHORD=830 + INCREASE
FRONT_DIST=80

POINTS=500
NACA='2410'
WIDTH=10
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
  for i in range(len(x)):
    print(x[i], y[i])
compute_scad()
