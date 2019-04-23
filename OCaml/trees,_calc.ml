type 'a tree =
  Empty | Node of 'a tree * 'a * 'a tree
;;

let deriv((f: float -> float), (dx: float)) =
  fun (x:float) -> (((f (x +. dx)) -. (f x))/.dx)
;;

let iterSum(f, (lo:float), (hi:float), inc) =
  let rec helper((x:float), (result:float)) =
    if (x > hi) then result
    else helper((inc x), (f x) +. result)
  in
  helper(lo,0.0)
;;

let integral((f: float -> float),(lo:float),(hi:float),(dx:float)) =
  let delta (x:float) = x +. dx in
  dx *. iterSum(f,(lo +. (dx/.2.0)), hi, delta)
;;

let indIntegral (f, (dx:float)) = 
  fun x -> integral (f, 0.0, x, dx)
;;

let rec mapTree f (t: 'a tree) =
  match t with
  |Empty -> Empty
  |Node (l, m, r) -> Node (mapTree f (l), f (m), mapTree f (r))
;;
