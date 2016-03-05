all:big_stable_delta.dxf big.dxf small.dxf

DEPS=lasercut/lasercut.scad

%.scad_2d: %.scad $(DEPS)
	openscad $< -D generate=1 -o $@.csg 2>&1 >/dev/null  | sed 's/ECHO: \"\[LC\] //' | sed 's/"$$//' | sed '$$a;' > $@ 
	sed -i "1iuse <lasercut/lasercut.scad>; \$$fn=60; \n projection(cut = false) \n"   $@

%.dxf: %.scad_2d 
	openscad $< -o $@

clean:
	rm -f *.dxf *.scad_2d  *.csg
