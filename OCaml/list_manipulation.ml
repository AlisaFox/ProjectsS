
let rec pairlists (l1, l2) = 
  match l1, l2 with 
  |(_::_, []) -> []
  |([], _)-> []
  | (x1::l1),(x2::l2) -> (x1,x2)::(pairlists(l1,l2)) 
;;            

(* list functions for mem and remove*)

let rec memberof (n, l) =
  match l with
  |[]-> false 
  | h :: t -> if h=n then true else memberof(n, t)
;;

let rec remove (item, lst) =
  match lst with
  |[]->[]
  |h::t -> if h=item then remove(item, t) else h :: remove(item, t)
;;

(* Find max item in a list and return it*)

let find_max l =
  let rec meow l acc=
    match l with
    |[] -> acc
    |h::t -> if h> acc then meow t h else meow t acc
  in 
  meow l (-1000000) 
;;

(* selection sort *)

let rec selsort l =
  match l with
  |[] -> []
  | _  -> let m = find_max l in m::(selsort(remove(m,l)))
;;
