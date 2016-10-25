;Michael Crinite
;Programming Languages
;Professor Tinkham
;Scheme Homework Programming Assignment
;09.23.2016
;-----------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------
(define	(score_one VoteL CandL)
	;Compares two lists, one a list of voter responses, one a list of candidate
	;responses. Returns a list containing the name of the candidate and
	;a score, which is decided based on the comparison of the responses:
	;	- if either party responds with a 0, the score is not changed
	;	- if the voter and candidate agree, the score is increased by 1
	;	- if the voter and candidate disagree, the score is decreased by 1
	(cond	((null? CandL)		0)
		((symbol? (car CandL))	
			(cons (car CandL) (cons (score_one VoteL (cdr CandL)) '())))
		((or (= (car VoteL) 0) (= (car CandL) 0))	
					(+ 0 (score_one (cdr VoteL) (cdr CandL))))
		((= (car VoteL) (car CandL))
					(+ 1 (score_one (cdr VoteL) (cdr CandL))))
		(else			(- (score_one (cdr VoteL) (cdr CandL)) 1)) ))

;-----------------------------------------------------------------------------------
(define (score_all VoteL allCands)
	;Compares two lists, one a list of voter responses, and the other a list of 
	;lists of candidate responses. Returns a list of lists of candidates and their
	;scores, as dictated by the scoring criteria described above - see score_one
	;documentation...
	(cond	((null? allCands)	'())
		(else	
			(cons (score_one VoteL (car allCands))
			      (score_all VoteL (cdr allCands)))) ))
;-----------------------------------------------------------------------------------
(define (separate_scores L)
	;From a list containing two-value lists of the form (<Candidate> <Score>)
	;returns a list of only the scores
	(cond	((null? L)		'())
		(else		(cons (cadar L) (separate_scores (cdr L)))) ))	
;-----------------------------------------------------------------------------------
(define (get_best_score L)
	;From a list containing only scores, finds the highest score
	(cond 	((null? L)	-1000000000000000000000000000000000000000000000000000)
		(else		(max (car L) (get_best_score (cdr L)))) ))
	;Hopefully no two people in existence disagree on more things than that, or
	;we have more problems than this program not working properly...
;-----------------------------------------------------------------------------------
(define (cand_list all_cand_scores highest)
	;From a list containing two-value lists of the format (<Candidate> <Score>)
	;and a number value representing the highest score in that list, chooses
	;all the candidates whose score matches that highest score and combines those
	;names into a list.
	(cond	((null? all_cand_scores)	'())
		((= (cadar all_cand_scores) highest)	
			(cons	(caar all_cand_scores) (cand_list 
				(cdr all_cand_scores) highest)))
		(else	(cand_list (cdr all_cand_scores) highest)) ))
;-----------------------------------------------------------------------------------
;This section is just for testing the program
(define (return_VoteL)
	;Returns the sample list given as an example on the homework sheet
	;that professor Tinkham gave out the first day of class
	(cond	(#T	'(0 0 0 1 1 1 -1 -1 -1 1)) ))

(define (return_allCands)
	;Returns a list of lists of candidates responses which was 
	;used in the same example as above on the homework sheet
	;that professor Tinkham gave out the first day of class.
	;Useful with (return_VoteL) to test the functionality
	;of this program.
	(cond	(#T	'((Adams   	 1  1  1  1  1  1  1  1  1  1)
			  (Grant	-1 -1 -1 -1 -1 -1 -1 -1 -1 -1)
			  (Polk		 1 -1  1 -1  1 -1  1 -1  1 -1)
			  (Jackson	 1  0  1  0  1  0  1  0  1  0)
			  (Taft		 0 -1  0 -1  0 -1  0 -1  0 -1)
			  (Ford		 1  1  1  1  0  0  0  0  0  0)
			  (Madison	 0  0  0  1 -1  0  0 -1  1  1))) ))
;The condition statement doesn't make sense, but initially there was
;more than just one condition. I left it in there just to not mess it up.
;-----------------------------------------------------------------------------------
(define (best_candidates Voter CandList)
	;Driver function. Calls all other functions necessary to determine
	;best candidates as described in the assignment.
	(cand_list (score_all Voter CandList) 
		   (get_best_score (separate_scores (score_all Voter CandList)))))
;-----------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------
(define (test)
	(best_candidates (return_VoteL) (return_allCands)))
;Should produce the same results as the homework handout!
;-----------------------------------------------------------------------------------	
