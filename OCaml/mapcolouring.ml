(* Question 1.1 *)

let areNeighbours ct1 ct2 (cht : chart) =
  List.mem (ct1, ct2) cht || List.mem (ct2, ct1) cht
;;

(* Question 1.2 *)

let canBeExtBy (col:colour) (ct: country) (ch : chart) =
  (List.for_all(fun x ->
       areNeighbours x ct ch == false)
      col)
;;

(* Question 1.3 *)

let rec extColouring (cht: chart) (colours : colouring) (cntry : country) =
  match colours with
  | []-> [[cntry]]
  |h :: t -> if canBeExtBy h cntry cht
      then ((([cntry] @ h) :: t): colouring)
      else (([h]:colouring) @ (extColouring cht t cntry))
;;

(* Question 1.4 *)

let rec removeDuplicates lst =
  match lst with
  | [] -> []
  |h :: t -> h :: (removeDuplicates (List.filter (fun x -> x <> h) t)) 
    
;;

(* Question 1.5 *)

let countriesInChart (cht: chart) =
  let rec flattenPairs l = match l with
    |  [] -> []
    | ((a, b)::t) -> a :: b :: (flattenPairs t)
  in removeDuplicates(flattenPairs cht)
;;

(* Quesiton 1.6 *)

let colourTheCountries (cht : chart) = 
  List.fold_left (fun z x -> extColouring cht z x) [] (countriesInChart cht)
;;

(* Question 2 *)

let rec insert comp (item: int) (list: rlist) = 
  let i = {data = item; next = ref None} in
  match !list with 
  | None -> list:= !(cell2rlist i)
  | Some c as n when comp(item , c.data) -> i.next := n; list := Some i
  | Some c -> insert comp item c.next
;;

(*In this question you will implement a simple map colouring problem. We will represent a map showing countries by describing which countries share a border. A country is just a string. A chart is simply a map (in the normal sense of the word) of some countries. It is represented as a list of pairs of countries. If (a, b) is in the list it means that the countries a and b share a border. This relation is symmetric but we will not put both (a, b) and (b, a) in the list.

We want to colour the chart so that two countries that share a border are not given the same colour. We will not name the colours; we simply view a colour as a set of countries that share the same colour; such a set is represented as a list of countries. A colouring is a set of colours; hence a set of sets of countries: this is represented as a list of lists of countries. The algorithm takes a chart, and an initially empty colouring and then tries to extend the colouring by adding countries from the chart. It works by naively checking if a country can be added to a given colour by making sure that it is not a neighbour of any of the countries already with that colour.

For this question, you need to implement 6 functions covering the logic of the full algorithm. We encourage you to use as much of the List module functions as you wish.

val areNeighbours : country -> country -> chart -> bool = <fun> should return true iff the two countries ct1 and ct2 given are in the chart, whether as (ct1, ct2) or (ct2, ct1).
val canBeExtBy : colour -> country -> chart -> bool = <fun> should return true iff the given country can be added to the given colour.
val extColouring : chart -> colouring -> country -> colouring = <fun> should return an extended version of the given colouring by inserting the given country into the first valid colour.
val removeDuplicates : ’a list -> ’a list = <fun> is pretty self-explanatory. However, make sure to keep the first instance of any duplicates.
val countriesInChart : chart -> country list = <fun> returns the list of countries involved in a chart with no duplicates.
val colourTheCountries : chart -> colouring = <fun> uses all previous functions to actually create a colouring! Careful however: we expect your solution to be at least as good as ours. Our solution fits into a single line; if your solution is too long and fails, think of what can be done simpler!
Question 2 : Imperative linked lists
This exercise shows you how to do low-level pointer manipulation in OCaml if you ever need to do that, using ref-based linked lists. 
Implement the function insert : (int * int -> bool) -> int -> rlist -> unit which inserts an element into a sorted linked list and preserves the sorting. You do not have to worry about checking if the input list is sorted; it will be sorted with respect to the comparison function given as the first argument. Your function will destructively update the list. This means that you will have mutable fields that get updated.


*)
