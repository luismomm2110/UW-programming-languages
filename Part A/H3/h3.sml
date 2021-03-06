(*HOMEWORK 3*)


exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern


datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(*1. Write a function only_capitals that takes a string list and returns a string list that has only
the strings in the argument that start with an uppercase letter. Assume all strings have at least 1
character. Use List.filter, Char.isUpper, and String.sub to make a 1-2 line solution.*)

val only_capitals  =
     List.filter(fn x => Char.isUpper(String.sub(x,0)))

(*2 Write a function longest_string1 that takes a string list and returns the longest string in the
list. If the list is empty, return "". In the case of a tie, return the string closest to the beginning of the
list. Use foldl, String.size, and no recursion (other than the implementation of foldl is recursive). *)

val longest_string1 =
    List.foldl (fn (x,y) => if String.size(x) > String.size(y) then x else y) ""

val test2 = longest_string1(["A", "B", "ABC"])

(* 3. Write a function longest_string2 that is exactly like longest_string1 except in the case of ties it returns the string closest to the end of the list. Your solution should be almost an exact copy of longest_string1. Still use foldl and String.size. usei L *)

val longest_string2 =
    List.foldl(fn(x,y) => if String.size(x) > String.size(y) then x else y) ""

(*4 Write functions longest_string_helper, longest_string3, and longest_string4 such that:
 longest_string3 has the same behavior as longest_string1 and longest_string4 has the
same behavior as longest_string2.
 longest_string_helper has type (int * int -> bool) -> string list -> string
(notice the currying). This function will look a lot like longest_string1 and longest_string2
but is more general because it takes a function as an argument.
 If longest_string_helper is passed a function that behaves like > (so it returns true exactly
when its first argument is stricly greater than its second), then the function returned has the same
behavior as longest_string1.
 longest_string3 and longest_string4 are defined with val-bindings and partial applications
of longest_string_helper.*)

  
 fun longest_string_helper f =
     List.foldl(fn(x,y) => if f(x,y) then x else y) ""

 val longest_string3 = longest_string_helper(fn (x, y) => String.size(x) >= String.size(y))


 val longest_string4 = longest_string_helper(fn(x,y) => String.size(x) >= String.size(y))


val test4a = longest_string3 ["A","bc","C"] = "bc"

val test4b = longest_string4 ["A","B","C"] = "C"


(*5. Write a function longest_capitalized that takes a string list and returns the longest string in
the list that begins with an uppercase letter, or "" if there are no such strings. Assume all strings
have at least 1 character. Use a val-binding and the ML librarys o operator for composing functions.
Resolve ties like in problem 2.*)

val longest_capitalized = longest_string2 o only_capitals


val test5 = longest_capitalized ["A","bc","C"] = "A"

(*6. Write a function rev_string that takes a string and returns the string that is the same characters in
reverse order. Use MLs o operator, the library function rev for reversing lists, and two library functions
in the String module. (Browse the module documentation to find the most useful functions *)
						     
val rev_string  =
    String.implode o List.rev o String.explode


(* 7. Write a function first_answer of type (’a -> ’b option) -> ’a list -> ’b (notice the 2 arguments are curried). 
      The first argument should be applied to elements of the second argument in order 
      until the first time it returns SOME v for some v and then v is the result of the 
      call to first_answer. 
   If the first argument returns NONE for all list elements, then first_answer should raise the exception NoAnswer. 
   Hints: Sample solution is 5 lines and does nothing fancy. *)

fun first_answer f xs  =
    case xs of
	[] => raise NoAnswer
        |  x::xs' => case f x  of
			  SOME  _ =>  x
		        | NONE  => first_answer f xs'




(*8 Write a function all_answers of type (’a -> ’b list option) -> ’a list -> ’b list option
(notice the 2 arguments are curried). The first argument should be applied to elements of the second
argument. If it returns NONE for any element, then the result for all_answers is NONE. Else the
calls to the first argument will have produced SOME lst1, SOME lst2, ... SOME lstn and the result of
all_answers is SOME lst where lst is lst1, lst2, ..., lstn appended together (order doesn’t matter).
Hints: The sample solution is 8 lines. It uses a helper function with an accumulator and uses @. Note
all_answers f [] should evaluate to SOME [] *)

fun all_answers f xs =
    let fun helper (ys, acc, g) =
	    case ys of
		[] => SOME acc
	        | y::ys' => case g y of
				NONE => NONE
			        | SOME t  => helper(ys', t@acc, g) 
    in 
       helper(xs, [], f)
    end 

val test8a = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE

val test8b = all_answers (fn x => if x = 2 then SOME [x] else NONE) [2,2,2] = SOME[2,2,2]



(*The remaining problems use these type definitions, which are inspired by the type definitions an ML implementation would use to implement pattern matching:

datatype pattern = Wildcard | Variable of string | UnitP | ConstP of int
| TupleP of pattern list | ConstructorP of string * pattern

datatype valu = Const of int | Unit | Tuple of valu list | Constructor of string * valu

Given valu v and pattern p, either p matches v or not. If it does, the match produces a list of string * valu
pairs; order in the list does not matter. The rules for matching should be unsurprising:
• Wildcard matches everything and produces the empty list of bindings.
• Variable s matches any value v and produces the one-element list holding (s,v).
• UnitP matches only Unit and produces the empty list of bindings.
• ConstP 17 matches only Const 17 and produces the empty list of bindings (and similarly for other
integers).
• TupleP ps matches a value of the form Tuple vs if ps and vs have the same length and for all i, the
i
th element of ps matches the i
th element of vs. The list of bindings produced is all the lists from the
nested pattern matches appended together.
• ConstructorP(s1,p) matches Constructor(s2,v) if s1 and s2 are the same string (you can compare
them with =) and p matches v. The list of bindings produced is the list from the nested pattern match.
We call the strings s1 and s2 the constructor name.
• Nothing else matches.  *)

(* 9. (This problem uses the pattern datatype but is not really about pattern-matching.) A function g has
been provided to you.
(a) Use g to define a function count_wildcards that takes a pattern and returns how many Wildcard
patterns it contains.
(b) Use g to define a function count_wild_and_variable_lengths that takes a pattern and returns
the number of Wildcard patterns it contains plus the sum of the string lengths of all the variables
in the variable patterns it contains. (Use String.size. We care only about variable names; the
constructor names are not relevant.)
(c) Use g to define a function count_some_var that takes a string and a pattern (as a pair) and
returns the number of times the string appears as a variable in the pattern. We care only about
variable names; the constructor names are not relevant *)

(*fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end *)


val count_wildcards = g(fn x  => 1) (fn y => 0)

val test9a = count_wildcards(Wildcard) = 1


val count_wild_and_variable_lengths =  g(fn x =>  1)(String.size)

val test9b = count_wild_and_variable_lengths(Variable "ABC") = 3


fun count_some_var(x,p)= g(fn x => 0) (fn s => if x = s then 1 else 0) p

val test9c = count_some_var("x", Variable("x")) = 1

(*Write a function check_pat that takes a pattern and returns true if and only if all the variables
appearing in the pattern are distinct from each other (i.e., use different strings). The constructor
names are not relevant. Hints: The sample solution uses two helper functions. The first takes a
pattern and returns a list of all the strings it uses for variables. Using foldl with a function that uses
@ is useful in one case. The second takes a list of strings and decides if it has repeats. List.exists may
be useful. Sample solution is 15 lines. These are hints: We are not requiring foldl and List.exists
here, but they make it easier. *)


fun check_pat p =
    let
	fun helper1(ps, acc) = 
	    case ps of
		Variable x => x::acc
	        | TupleP p => List.foldl(fn(p, acc) => helper1(p, acc)) acc p
	        |  _ => []
	fun helper2(xs) =
	    case xs of
		x::xs' => case List.exists(fn(a) => x=a) xs' of
			     true => false
			     |false  => case xs' of
					   [] => true
				           |_ => helper2(xs')
    in
	helper2(helper1(p, []))
    end

				      
val test10 = check_pat (Variable("x")) = true


(*Write a function match that takes a valu * pattern and returns a (string * valu) list option,
namely NONE if the pattern does not match and SOME lst where lst is the list of bindings if it does.
Note that if the value matches but the pattern has no patterns of the form Variable s, then the result
is SOME []. Hints: Sample solution has one case expression with 7 branches. The branch for tuples
uses all_answers and ListPair.zip. Sample solution is 13 lines. Remember to look above for the
rules for what patterns match what values, and what bindings they produce. These are hints: We are
not requiring all_answers and ListPair.zip here, but they make it easier. *)

fun match (v, p) =
    case (v, p) of
	(_, Wildcard) => SOME []
       |(_, Variable s) => SOME [(v,s)]
       | (Unit, UnitP) => SOME []
       | (Const a, ConstP b )  => if a=b then SOME[] else NONE 
       | (Tuple vs, TupleP ps) => if List.length vs = List.length ps
	 then case all_answers match (ListPair.zip(vs, ps)) of
			   SOME [(a,b)] => SOME [(a,b)]
			 | _  => NONE 
         else NONE
       | (Constructor(s1, v1),ConstructorP(s2, p1)) => if s1=s2 then match(v1, p1)
						      else NONE
       | (_,_) => NONE

val test11 = match (Const(1), UnitP) = NONE


		  
 (* 12. Write a function first_match that takes a value and a list of patterns and returns a
(string * valu) list option, namely NONE if no pattern in the list matches or SOME lst where
lst is the list of bindings for the first pattern in the list that matches. Use first_answer and a
handle-expression. Hints: Sample solution is 3 lines. *)

fun first_match (v, ps) =
    case ps of
	[] => NONE
        |p::ps'  => case match(v, p) of
			SOME [(a, b)] => SOME [(b, a)]
		       | SOME []  => SOME [] 
		       |_ => first_match(v, ps')

val test12 = first_match (Unit, [UnitP]) = SOME []
