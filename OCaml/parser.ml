(* The type of parsed expression trees *)
type exptree =
  | Var of char
  | Expr of char * exptree * exptree

(* A list of valid variable names *)
let charSet =
  let rec aux i acc =
    if i < 97 then acc else aux (i-1) ((Char.chr i) :: acc)
  in
  aux 122 []

(* Returns true if x is an element of lst, false otherwise *)
let isin (x: char) lst =
  List.exists (fun y -> x = y) lst
  
  (* Question 1: Parsing *)
  (*The input will be just plain strings and the output has to be an exptree. The input strings consist of simple algebraic expressions with + and * and one-character symbols that are just lower-case letters. It is also possible to use parentheses in the input expressions. Blanks are not allowed in the input1. The parser itself will consist of three mutually recursive functions as explained in class; see the given template. *)
let parse (inputexp: string): exptree =
  let sym = ref inputexp.[0] in
  let cursor = ref 0 in

  let getsym () =
    cursor := !cursor + 1;
    sym := inputexp.[!cursor]
  in

  let rec expr (): exptree = 
    begin 
      let result = term() in 
      match !sym with
      |'+'-> 
          getsym(); if !sym = '*' then Expr ('+',result,term())
          else Expr ('+', result, expr());
      | _-> result 
    end
    
        

  and term (): exptree = 
    begin 
      let result = primary() in 
      match !sym with
      | '*' -> 
          getsym(); if !sym = '*' then Expr ('*',result,primary())
          else Expr ('*', result, term());
      | _ -> result 
    end

  and primary (): exptree = 
    if !sym = '('
    then begin
      getsym ();
      let result = expr () in
      if !sym <> ')' then
        failwith "Mismatched parens"
      else if !cursor = (String.length inputexp) - 1  then
        result
      else begin
        getsym ();
        result
      end
    end
    else
    if isin !sym charSet then
      if !cursor = (String.length inputexp) - 1 then
        Var !sym
      else
        let result = Var !sym in
        begin
          getsym ();
          result
        end
    else
      failwith "In primary"
  in
  expr ()

(* Question 2: Code Generation *)
(*In this question you will implement a toy code generator for the very simple stack machine as explained in class on March 13th. Use the output from the parser as input to the code generator. The code generator should just print the "machine instructions". *)
let tempstore = ref 0

let codegen (e: exptree) =
  let rec helper ((e: exptree), (tag: char)) =
    match e with
    | Var c -> Printf.printf "LOAD  %c\n" c
    | Expr(op, l, r) ->
        if tag = '=' then
          begin
            if(op = '+') then
              begin
                helper(l, '=');
                match r with
                |Var c-> Printf.printf "ADD  %c\n" c
                |_ -> helper (r, '+')
              end
            else
              begin
                helper (l, '=');
                match r with
                |Var c-> Printf.printf "MUL  %c\n" c
                |_ -> helper (r, '*')
              end
          end
        else begin
          tempstore := !tempstore + 1;
          (* Your code for dealing with STORE goes here *)
          Printf.printf "STORE %i\n" !tempstore;
          helper(l, '=');
          (match r with
           |Var c ->  if op = '+' then Printf.printf "ADD  %c\n" c 
               else Printf.printf "MUL  %c\n" c
           |_->helper(r, op)
          );
          (if (tag = '+') then
                 
             Printf.printf "ADD %i\n" !tempstore
           else 
             Printf.printf "MUL %i\n" !tempstore);
          tempstore := !tempstore - 1 
        end
  in
  helper (e, '=');;
