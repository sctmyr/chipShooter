// Poker chip shooter
// Middle school physics, elastic potential energy lab
// OpenScad script--Free download for Windows/Mac/Linux
//   .. Programatically design objects.
//   .. GUI 3d sketch products are soo 1990.
//   .. Only thing cooler is manifoldcad.org and the manifold project.

tiny=.01;
gap=.5; 
ledge=2; // Under projectile
projectile=[37.5,37.5,2.2]; // poker chip
//projectile=[25.7,25.7,7.8+gap]; // domino
bore=[100,projectile.x,projectile.z];
thick=4;
barrel=[100,projectile.y+gap*2+thick*2,projectile.z+gap+ledge+thick];
width=projectile.y+gap*2;

module Clip(dir){
  // Rubber band clips on barrel
  gap=1;
  c=[thick,thick,thick];
  width=projectile.y+gap*2;
  translate([width+thick*2,0,barrel.z-thick])
  hull(){
    translate([width-thick,0,0])
    cube(c);
    translate([0,dir*(thick+gap*4),0])
    cube(c);
  }
}

module Clips(){
  Clip(-1);
  translate([0,barrel.y-thick,0])
  Clip(1);
}

module Bore(cut=0){
  translate([-tiny*cut,(1-cut)*gap,-tiny*cut])
  hull(){
    translate([0,thick,ledge])
    cube(bore+[cut*tiny*2,cut*gap*2,cut*gap]);
    translate([0,thick+ledge,0])
    cube(bore+[cut*tiny*2,cut*gap*2-ledge*2,0]);
  }
}

module Barrel(){
  z=barrel.z+thick;
  c=projectile.x/2+thick*2;
  module CutCyl(){
    translate([0,barrel.y/2,projectile.z+ledge])
    cylinder(d=bore.y,h=barrel.z+thick*2);
  }
  difference(){
    cube(barrel);
    Bore(cut=1);
    // Cutout to save material and view
    hull(){
      translate([c,0,0])
      CutCyl();
      translate([barrel.x-c,0,0])
      CutCyl();
    }
  }
  Clips();
}

module Hammer(){
  back=10;
  module CutCyl(){
    translate([width/2,barrel.y/2,-tiny])
    cylinder(d=barrel.y/2,h=barrel.z+thick*2);
  }
  difference(){
    union(){
      z=barrel.z-gap;
      Bore();
      // Back grip
      translate([-back+tiny,0,0,])
      cube([back,barrel.y,barrel.z]);
    }
    // Cutout to save material
    hull(){
      CutCyl();
      translate([barrel.x-width,0,0])
      CutCyl();
    }
    // Cut ledge
    translate([barrel.x-projectile.x*.85,thick,ledge])
    cube([projectile.x,bore.y+gap*2,barrel.z]);
    // Half-centimeter ruler
    translate([0,barrel.y-thick-4,-tiny])
    for(i=[1:13]){
      translate([i*5,0,barrel.z-6])
      cylinder(d=3,h=3,$fn=4);
    }
    // Back grip, groove for rubber band
    hull(){
      z=barrel.z;
      translate([-back-tiny,-tiny,0,])
      cube([tiny,barrel.y+tiny*2,z]);
      translate([-back-tiny+z/2,-tiny,z/2])
      cube([tiny,barrel.y+tiny*2,tiny]);
    }
  }  
}

module Projectile(){
  translate([barrel.x-projectile.x/2+5,barrel.y/2,ledge])
  cylinder(d=projectile.x,h=projectile.z);
}

module Assembled(){
  //rotate([0,180,0])
  rotate([0,0,180])
  translate([-barrel.x,-barrel.y,0])
  //translate([-barrel.x,0,-(barrel.z+thick)])
  Barrel();
  //translate([3,0,0])
  Hammer();
  Projectile();
}

module Print(){
  rotate([180,0,0])
  translate([0,thick*1.5,-barrel.z])
  Barrel();
  Hammer();
}

//Print();
Assembled();
//Hammer();
//rotate([180,0,0]) Barrel();