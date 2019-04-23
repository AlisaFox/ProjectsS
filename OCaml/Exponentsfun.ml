let close ((x: float), (y: float)) = abs_float (x -. y) < 0.0001;;

let square (x: float) = x *. x;;

let cube (x:float) = x *. x*. x;;

let odd n = (n mod 2) = 1;;

let mysqrt (x:float) = 
  let rec iterate g =
    let g2 = square g in
    if close (g2, x) then g
    else
      iterate ((g +. (x /. g)) /. 2.0) 
  in 
  iterate 1.0 ;;
        

  
let cube_root (x:float) = 
  let rec iterate2 g =
    let g3 = cube g in
    if close (g3, x) then g
    else
      iterate2 (((2.0 *. g) +. (x /.( g *. g))) /. 3.0) 
  in 
  iterate2 1.0 ;;

let fast_exp (base, power) = 
  if base = 0 then 0
  else
  if power = 0 then 1
  else
    let rec rpe base power acc =
      if power = 0 then acc
      else if (odd power) then
        rpe (base*base) (power - 1) (acc * base)
      else
        rpe (base*base) (power/2) (acc * acc)
    in
    rpe base power 1 ;;

                                         

                           

