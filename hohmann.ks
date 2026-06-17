parameter target_body_name.

set home to ship:body.
set target to body(target_body_name).
set mu to home:mu.
set ship_r to (ship:orbit:apoapsis + ship:orbit:periapsis)/2 + home:radius.
set target_r to (target:orbit:apoapsis + target:orbit:periapsis)/2 + home:radius.

set period_maneuver to 2*constant:pi*sqrt(((target_r+ship_r)/2)^3/mu).
set transfer_angle to constant:pi*(1 - period_maneuver/(target:orbit:period)).
set hohmann_burning_dv to sqrt(mu/ship_r)*(sqrt(2*target_r/(target_r + ship_r)) - 1).
set target_angle to 2*constant:pi*targer:orbit:eta:apoapsis/target:orbit:period.

set uhv to ship:up:vector.
set upv to ship:prograde:vector.
set utv to target:up:vector.

set vdot_target to vdot(uhv, utv)/(uhv:mag * utv:mag).
set vdot_position to vdot(utv, upv)/(utv:mag * upv:mag).
set final_angle to arcCos(vdot_target).

if vdot_position < 0{
    set final_angle to 2*constant:pi-final_angle.
}


set final_angle to final_angle - transfer_angle.
set final_angle_reason to 0.
set dt to 0.


from {local x is 0.} until {(x = 10).} step {set x to x+1.} do{
    set ds to 2*constant:pi*sqrt(ship:body:mu)*(sin(target_angle) - sin(final_angle) + sqrt(ship:body:mu/target:orbit:apoapsis^3)*(target_angle - final_angle)).
    set final_angle_reason to ds/(2*constant:pi).
    set dt to final_angle_reason*ship:orbit:period.
    set final_angle to final_angle*final_angle_reason.   
    
}

set target_node to node(time:seconds + dt, 0, 0, hohmann_burning_dv).
add target_node.
