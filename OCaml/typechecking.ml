type typExp =
  | TypInt
  | TypVar of char
  | Arrow of typExp * typExp
  | Lst of typExp;;

type substitution = (char * typExp) list;;

let te1 = Arrow(TypInt, Arrow(TypVar 'c', TypVar 'a')) ;;
let te3 = Arrow(TypVar 'a',Arrow (TypVar 'b',TypVar 'c')) ;;

(* Question 1.1 *)
let rec occurCheck (v: char) (tau: typExp) : bool =
  match tau with
  |TypVar c -> if c=v then true else false
  |TypInt -> false
  |Arrow (a, b) -> (occurCheck v a) || (occurCheck v b)  
  |Lst l -> occurCheck v l 
;;

(* Question 1.2 *)
let rec substitute (tau1 : typExp) (v : char) (tau2 : typExp) : typExp =
  if occurCheck v tau2 then
    match tau2 with
    |TypVar c -> if c=v  then  tau1  else tau2  
    |TypInt -> tau2
    |Arrow (a, b) -> Arrow(substitute tau1 v a, substitute tau1 v b)
    |Lst l -> Lst(substitute tau1 v l)
  else tau2
;;

(* Question 1.3 *)
let applySubst (sigma: substitution) (tau: typExp) : typExp =
  let rec subst s t : typExp = 
    match s with
    |[] -> t
    |(x,y)::[] -> substitute y x t
    |(x,y)::xs -> substitute y x (subst xs t)
  in subst sigma tau
;;

(* Question 2 *) 
let rec unify (tau1: typExp) (tau2:typExp) : substitution = 
  if tau1 = tau2 then []
                      
  else match tau1,tau2 with 
    
    | TypVar x, typExp ->
        if (occurCheck x tau2) then raise (Failure "sorry")
        else [(x, typExp)]
             
    | typExp, TypVar y ->
        if (occurCheck y tau1) then raise (Failure "naaaaah")
        else [(y, typExp)]    
             
    | Arrow(a,b), Arrow(c,d) ->
        let z = unify a c in 
        let sub1 = applySubst z d in
        let sub2 = applySubst z b in
        if z = [] then unify b d else
          List.rev (z @ List.rev (unify sub2 sub1))
            
    | Lst l1, Lst l2 -> unify l1 l2 
                        
    | _ -> raise (Failure "moooo")   (*2,4,5,8,11*)
;; 


(*In this assignment we will implement part of a type checker for a new made-up language called Monty. In this assignment we are looking exclusively at the part of Monty that deals with its type system. We will define an OCaml type called typExp to encode the types of Monty. Note that Monty has a polymorphic type system.

We will use this to implement unification which is part of the type reconstruction algorithm for Monty. Let us recap basic facts about unification first. Unification is one of the central operations in type-reconstruction algorithms, theorem proving and logic programming systems. In the context of type-reconstruction, unification tries to find an instantiation for the free variables in two types τ 1 and τ 2 such the two types are syntactically identical. If such an instantiation exists, we say the two types τ 1 and τ 2 are unifiable.

The definition of the types of Monty is provided in the prelude. Remember we are writing a program in OCaml that deals with another language (Monty). Do not confuse the types of the language Monty with OCaml types. The type definition below is written in OCaml it describes the types of Monty.

We want to implement unification for Monty type expressions. This means finding a substitution for the type variables. A substitution is a list of pairs; each pait gives a type expression for a type variable. We say that two type expressions are unifiable if there is a substitution that makes them identical. This is key step in the type reconstruction algorithm.

We are using simple characters to represent type variables with the constructor TypVar prefixing it. In the substitution we just write the character and not this constructor but this is just for convenience. We have only got one base type (TypInt), one unary type constructor (Lst) and one binary type constructor (Arrow). A type that we would write as int→(‘a→‘b list) would be written in our representation as

Arrow(TypInt, Arrow(TypVar ’a’, Lst (TypVar ’b’)))
Another polymorphic type expression may look like this: Arrow(TypVar ’a’, Arrow (TypInt, Lst (TypInt))). These are, of course, not the same. Are they unifiable? In other words, is there some replacement for the type variables that makes these two type expressions identical? Yes there is! If we replace both the type variables with TypInt they will both be identical. This is the kind of thing that we will write our program to discover. Here is a script of the program in action.

Notice that this is more than simple pattern matching. Each type expression constrains the other. We are finding the most general unifier.

Question 1 [40 pts]
Q1.1 : occurCheck
In this question you will implement some of the auxiliary functions needed for unification. First of all recall that we do not allow a substitution where a variable is replaced by a type expression containing it. So we need to check if a type variable occurs in a type expression. This is called the “occur check.” Before we call occur check, we must strip off the TypVar constructor.

Implement the function occurCheck : v : char -> tau : typExp -> bool that does the above

Q1.2 : subsitute
A substitution is a list of tuples of characters and type expressions (see prelude). Implement a function substitute : tau1:typExp -> v:char -> tau2:typExp -> typExp that performs a replacement of a variable with a type expression. This should replace all occurences of v with tau1 inside tau2.

Q1.3 : applySubst
The above function does just one replacement. A true substition is a list of such replacements; therefore, implement the function applySubst : sigma:substitution -> tau:typExp -> typExp. applySubst should apply the substitutions in a list in order from right to left.

Question 2 [60 pts]
Implement the function unify : tau1:typExp -> tau2:typExp -> substitution which checks whether two types are unifiable and produces the most general unifier if there is a unifier, or fail with an appropriate error message. 
*)
