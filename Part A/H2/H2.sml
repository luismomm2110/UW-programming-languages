(*Homework 2*)

fun  same_string(s1 : string, s2 : string) =
     s1 = s2


(* problem 1 *)

 (* A *)

fun all_except_one(s1, xs) =
    case xs of
	[] =>  NONE
      | x::xs' => case same_string(s1,x) of
		      true  => SOME(xs')
		    | false  => case all_except_one(s1,xs') of
				    NONE => NONE
				 | SOME(ys')  => SOME(x::ys')
		      
(* B *)
						     
fun get_substitions1(xss, s) = (*string list list*string) -> string list *)
    case xss of
	[] =>  []
       | xs::xss' => case all_except_one(s, xs) of
		       NONE => get_substitions1(xss',s)
		     | SOME(xs') => xs'@get_substitions1(xss', s) 
    
(*C*)

fun get_substition2(xss, s) =
    let fun helper(xss, acc) =
	    case xss  of
		[ ]  => acc
	        |  xs::xss'  => case all_except_one(s, xs) of
				 NONE => helper(xss', acc)
			         |SOME(xs) => helper(xss', xs@acc)
    in
	helper(xss, [])
    end 

			
(*D*)

(*string list list *(string*string*string*string) -> (string*string*string*string list) )*)

(*onde tiver sub eu troco o primeiro nome de todos da lista *)

fun similar_names(xss, {first=first, middle=middle, last=last}) =
    let
	val list_names= first::get_substition2(xss, first)

	fun helper(list_names, acc) =
	    case list_names of
		[ ] => acc
	      | x::xss' => helper(xss', {first=x, middle=middle, last=last}::acc)
    in
	helper(list_names, [])
    end
	
(*      Question 2    *)
	
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = King | Queen | Jack | Ace | Num of int
type card = suit*rank

datatype color = Black | Red
datatype move = Discard of card | Draw

exception IlegalMove


(*A*)
fun card_color(x,y) =
    case x of
	Diamonds  => Red
       | Hearts  => Red
       | _  => Black 

(*B*)
fun card_value(x,y) =
    case y of
	Num y => y
      | Ace  => 11
      |  _  =>  10

(*C*)
		    
fun remove_card(cs, c, e) =
    case cs of
	[] => raise e
        | head::cs'  => case c = head of
 			   true => cs'
		           | false => remove_card(cs', c, e)

(*D*)


fun all_same_color(cs) = (*return true if same color*)
    case cs of
      [] => true
      | c::[]  => true
      | c::c'::cs'' => case card_color(c) = card_color(c') of
			   true  => all_same_color(c'::cs'')
			 | false => false


(*E*)

fun sum_cards(cs) =   (*sum the values in the list *)
    let 
    	fun helper (cs, acc) =
	    case cs of
		[] => acc
	        | c::cs'  => helper(cs', card_value(c) + acc)
    in
	helper(cs,0)
    end

    
(*F*)

fun score(cs,goal) =
    let
	val pre_sum = sum_cards(cs)
			       
	fun score_calculator(cs, pre_sum) =
	    case pre_sum > goal of
		true => 3*(pre_sum - goal)
	        | false => goal-pre_sum

	val pre_score =  score_calculator(cs, pre_sum)
	
	fun helper(cs) =
	    case all_same_color(cs) of
		true => pre_score div 2
	      | false =>  pre_score

    in
	helper(cs)
    end



	

fun officiate(cs, mvs, goal) = (* -> goal *)
    let
	fun helper(cs, hd, mvs, goal) = 
	    case cs of
	       [] => score(hd, goal)
	       | c::cs' => case mvs of
			       [] => score(hd,  goal)
			       | mv::mvs' => case mv of
						    Discard(a) =>helper(cs', remove_card (hd, a, IlegalMove), mvs', goal)
					          | Draw => case sum_cards(c::hd) > goal of
                                                                true => score(c::hd, goal)
							       |_  => helper(cs', c::hd, mvs', goal)
    in
	helper(cs, [], mvs, goal)
    end 
			     
			     
    
