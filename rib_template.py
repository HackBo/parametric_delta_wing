from naca import naca4

POINTS=500
NACA='2412'
WIDTH=10
CHORD=830

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
  for i in range(len(x)):
    print(x[i], y[i])

compute_scad()
