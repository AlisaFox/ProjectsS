type transaction = Withdraw of int | Deposit of int | CheckBalance | ChangePassword of string | Close;;

let makeProtectedAccount ((openingBalance: int), (password: string)) =
  let passw= ref password  in
  let balance = ref openingBalance in
  let closed = ref false in 
  fun ((p: string),(t: transaction)) -> 
    if !closed == false then 
      begin 
        if !passw = p then
          match t with
          | Withdraw(m) ->  if (!balance >= m)
              then
                ((balance := !balance - m);
                 (Printf.printf "The new balance is: %i." !balance))
              else
                print_string "Insufficient funds."
          | Deposit(m) ->
              ((balance := !balance + m);
               (Printf.printf "The new balance is: %i." !balance)) 
          | CheckBalance -> (Printf.printf "The balance is: %i." !balance)
          | ChangePassword(s) ->  ((passw := s);
                                   print_string "Password changed.")
          | Close -> ((closed:= true);
                      print_string "Account successfully closed.")
        else  print_string "Incorrect password."
      end
    else print_string "Account closed."
                     
;;

(*In this exercise, you are asked to modify this code and generate a password-protected bank account. Any transaction on the bank account should only be possible, if one provides the right password. For this, implement the function makeProtectedAccount with the arguments and types shown below.

val makeProtectedAccount : int * string -> string * transaction -> unit = <fun>
This function takes in the opening balance as a first argument and the password as a second, and will return a function which when given the correct password and a transaction will perform the transaction. One crucial difference to be noted right away is that in the new code I want you to print the balance on the screen instead of returning it as a value.

Here are some examples.

  # let zoe = makeProtectedAccount(1000, "BiologyRocks");;
  val zoe : string * transaction -> unit = <fun>
  # let elisa = makeProtectedAccount(500, "ArtsStudentsArePoor");;
  val elisa : string * transaction -> unit = <fun>
  # let alison = makeProtectedAccount(2500, "MathIsTheBest");;
  val alison : string * transaction -> unit = <fun>
  # elisa("ArtsStudentsArePoor", Withdraw 100);;
  The new balance is: 400.
  - : unit = ()
  # alison("MathIsTheBest", Deposit 200);;
  The new balance is: 2700.
  - : unit = ()
  # zoe("BiologyRocks", CheckBalance);;
  The balance is: 1000.
  - : unit = ()
  # zoe("BiologySucks", Withdraw 100);;
  Incorrect password.
  - : unit = ()
  # zoe("BiologyRocks", Withdraw 1500);;
  Insufficient funds.
  - : unit = ()
  # elisa("ArtsStudentsArePoor", ChangePassword "CSwillMakeMeRich");;
  Password changed.
  - : unit = ()
  # elisa("ArtsStudentsArePoor", Deposit 100);;
  Incorrect password.
  - : unit = ()
  # elisa("CSwillMakeMeRich", Deposit 200);;
  The new balance is: 600.
  - : unit = ()
  # alison("MathIsTheBest", Close);;
  Account successfully closed.
  - : unit = ()
  # alison("MathIsTheBest", CheckBalance);;
  Account closed.
  - : unit = ()
  *)
