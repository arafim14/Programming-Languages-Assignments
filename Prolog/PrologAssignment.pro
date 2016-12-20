% Michael Crinite
% Programming Languages
% Professor Tinkham
% PROLOG Homework Programming Assignment
% 11.09.2016
%---------------------------------------------

% score(+VoteR, +CandR, -Score)
% Score is Candidate's score based on the comparison of their
% 	responses to those of the Voter:
% 	1. Either responds 0 -> Score is unchanged
% 	2. Both agree        -> Score is incremented
% 	3. Both disagree     -> Score is decremented
% VoteR is the list of voter responses, CandR is the list of Cand responses
score([], [], 0). 
score([VoteH | VoteT], [CandH | CandT], Score) :- 
				(VoteH == 0 ->
				score(VoteT, CandT, Score);
				CandH == 0 ->
				score(VoteT, CandT, Score);
				VoteH == CandH ->
				score(VoteT, CandT, Tscore),
				Score is Tscore + 1;
				score(VoteT, CandT, Tscore),
				Score is Tscore - 1).

% scoreCand(+VoteR, +CandR, -CandScore)
% CandScore is a list of the format: [CandidateName, CandidateScore]
% VoteR is the list of Voter responses, CandR is the list of Cand responses
scoreCand(VoteR, [H | T], [H, N]) :- score(VoteR, T, N).

% candidates(+VoteL, +Candidates, -Scores)
% Scores is the full list of Candidates in the format: [Name, Score]
% VoteL is the list of voter responses, Candidates is the full list
% of candidates and their responses
candidates(_, [], []).
candidates(VoteL, [H | T], [Result | S]) :- 
				candidates(VoteL, T, S),
				scoreCand(VoteL, H, Result).  

% highest(+CandidateScores, -Highest)
% Highest is the largest score in CandidateScores
% CandidateScores is the result of candidates
highest([], -11).
highest([[_ , T] | Rest], Result) :-
				highest(Rest, N),
				T > N, Result = T.
highest([[_ , T] | Rest], Result) :-
				highest(Rest, N),
				T < N, Result = N.	
							
% bestCandidates(+Voter, +Candidates, -BestMatches)
% BestMatches is the candidate in Candidates who agreed
% 	 most with the Voter
best_candidates(Voter, [[H | S] | T], BestMatches) :-
				candidates(Voter, [[H | S] | T], X),
				highest(X, Y),
				score(Voter, S, Z),
				Z == Y, BestMatches = H.
best_candidates(Voter,[_ | T], BestMatches) :-
				best_candidates(Voter, T, BestMatches).	
