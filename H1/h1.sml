fun is_older(first :  (int*int*int), second : (int*int*int)) =
     (#1 first*365) + (#2 first*30) + #3 first < (#1 second*365) + (#2 second*30) + #3 second 

   (* 2 *)

fun number_in_month (data_list : (int*int*int) list, month : int) =
    if null(data_list)
    then 0
    else
	if #2 (hd data_list) = month
	then 1 + number_in_month(tl data_list, month)
	else number_in_month(tl data_list, month)

 (* 3 *)
			    
fun numbers_in_month(data_list: (int*int*int) list, month_list: int list) =
    if null(month_list)
    then 0
    else number_in_month(data_list, hd month_list) + numbers_in_month(data_list, tl month_list)

(*4*)
fun date_in_month(data_list: (int*int*int) list, month: int) = 
    if null data_list then []
    else if (#2 (hd data_list)) = month then hd (data_list) :: date_in_month(tl data_list, month)
    else date_in_month(tl data_list, month)
		  
(*5*)

fun dates_in_months(data_list: (int*int*int) list, month_list: int list) =
    if null month_list then []
    else  date_in_month(data_list,hd month_list)@dates_in_months(data_list, tl month_list)

								(*6*)

fun get_nth (words : string list, n : int) =
    if n = 1 then hd words
    else get_nth(tl words, n - 1)

(*7*)
								
fun date_to_string (date: (int*int*int))=
    let val months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in
	get_nth(months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end

	(*8*)

fun number_before_reaching_sum (numberList: int list, sum: int) =
    let fun search_sum(i: int, searchList: int list, searchSum: int) =
	    if hd searchList >=  searchSum
	    then i-1
	    else search_sum(i+1, tl searchList, searchSum - hd searchList)
    in
	search_sum(1, numberList, sum)
    end

	(*9*)

fun what_month(day: int) =
    let val months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
	number_before_reaching_sum(months, day) + 1
    end 
	 
	
fun month_range (day1 : int, day2 : int) =
    let	fun countup_month(from: int, to: int) =
	if from = to 
	then what_month(to)::[]
	else what_month(from) :: countup_month(from+1,to)
    in
	if day1 > day2 then [0]
	else countup_month((day1), (day2))
    end


fun oldest(data_list: (int*int*int) list) =
    if null data_list then NONE
    else
	let fun oldest_nonempty(data_list: (int*int*int) list) =
		if null (tl data_list) then hd data_list
		else let val tl_oldest = oldest_nonempty(tl data_list) 
		     in
			 if is_older(hd data_list, tl_oldest)
		         then hd data_list
		         else tl_oldest
		     end 		         
	in
	    SOME(oldest_nonempty(data_list))
	end
	


