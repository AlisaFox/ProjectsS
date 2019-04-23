(*returns all duplicates of two lists*)
let rec common twolists =
  match  twolists with
  | [],[]-> []
  | [], _::_ -> []
  | (h1::t1),(t2) -> 
      if memberof (h1, common(t1, t2)) then common (t1, t2) 
      else if memberof(h1, t2) then h1 :: common(t1,t2)
      else common(t1, t2) 
;;

(*Split a list into two equal sized ones*)

let rec split l =
  match l with
  |[]-> [],[] 
  |[ _ ] as t1 -> t1, []
  | h::t -> let t1, t2 = split t in
      h::t2, t1

(* implement merge. *)

let rec merge twolists =
  match twolists with
  |[],[] -> []
  |[], l -> l
  |l, [] -> l
  |(h1::t1), (h2::t2)->
      if h1> h2 then h2:: merge (h1::t1, t2) else h1:: merge(t1, h2::t2)
;;

(*  combine split and merge and use them to implement mergesort. *)

let rec mergesort l =
  match l with
  |[]-> []
  |[_] as x -> x
  |x ->let l1, l2 = split l in 
      merge (mergesort l1, mergesort l2) 
;;
