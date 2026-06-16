parameter target_body_name.

set home to ship:body.
set target to body(target_body_name).
set mu to home:mu.
set ship_r to (ship:orbit:apoapsis + ship:orbit:periapsis)/2 + home:radius.
set target_r to (target:orbit:apoapsis + target:orbit:periapsis)/2 + home:radius.

set period_maneuver to 2*constant:pi*sqrt(((target_r+ship_r)/2)^3/mu).
set transfer_angle to constant:pi*(1 - period_maneuver/(target:orbit:period)).
set hohmann_burning_dv to sqrt(mu/ship_r)*(sqrt(2*target_r)/(target_r + ship_r) - 1).

set uhv to ship:up:vector.
set upv to ship:prograde:vector.
set utv to target:up:vector.

set vdot_target to vdot(uhv, utv)/(uhv:mag * utv:mag).
set vdot_position to vdot(utv, upv)/(utv:mag * upv:mag).
set final_angle to arcCos(vdot_target) - transfer_angle.

if vdot_position < 0{
    set final_angle to 2*constant:pi-final_angle.
}

set dt to 0.
from {local x is 0.} until {(x = 10).} step {set x to x+1.} do{
    local angle_target is 2*constant:pi * (1-target:orbit:eta:apoapsis/target:orbit:period).
    local angveltt is 2*constant:pi/target:orbit:period - target:orbit:eccentricity*cos(angle_target).
    local angveltsh is 2*constant:pi/ship:orbit:period - ship:orbit:eccentricity*cos(final_angle).
    local reason is angveltt/angveltsh.
    set dt to dt + final_angle*ship:orbit:period/(2*constant:pi).
    set final_angle to final_angle*reason.
}

set target_node to node(time:seconds + dt, 0, 0, hohmann_burning_dv).
add target_node.
