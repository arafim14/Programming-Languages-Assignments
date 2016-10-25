-- Michael Crinite
-- Programming Languages
-- Professor Tinkham
-- Ada Homework Program Assignment
--
-- AdaAssignment.adb

---------------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure AdaAssignment is

---------------------------------------------------------------------------

-- This program will accept an input of:
-- 	One line of TEN Integers representing the voter's responses
--	One line of ONE Integer (N) representing the amount of candidates
-- 	N pairs of lines containing:
--		One line with the "name" of the candidate (a single character)
--		One line of TEN Integers representing the candidate's responses
-- The program will output the candidates that have the highest
-- "agreement score" with the voter.

---------------------------------------------------------------------------

	-- The final index in all response  arrays
	Last	: constant Integer	:= 10;

	-- Declaration of ResponseArray for storing Candidate/Voter responses
	subtype ResponseArray_Index is Integer range 1..Last;
	type ResponseArray is array(ResponseArray_Index) of Integer;

	-- The array which will contain the voter's scores
	Voter	: ResponseArray;

	-- The number of candidates
	NumCands: Integer;
	MaxCands: constant Integer	:= 25;

	-- Declaration of CandResponse record for storing a candidate's
	-- Name and an array of their responses.
	type CandResponse is record
		Cand_Name	:	Character;
		Responses   	:	ResponseArray;
	end record;

	-- Declaration of array of records for storing all
	-- Candidate names/responses
	subtype RecordArray_Index is Integer range 1..MaxCands;
	type RecordArray is array(RecordArray_Index) of CandResponse;

	-- The array which will contain the CandResponse(s)
	Cands	: RecordArray;

	-- For storing the candidates scores
	type ScoreArray is array(RecordArray_Index) of Integer;

	Scores	: ScoreArray;
	Highest	: Integer := -15; -- Score lower than -10 is impossible (?)

---------------------------------------------------------------------------
	procedure Read_Responses is
	-- Read a valid set of responses and store them in an array
		Num	: Integer;
		begin
			-- Put("Enter voter's responses: "); 
			for I in ResponseArray_Index loop
				Get(Num);
				Voter(I) := Num;
			end loop;
			Skip_Line; -- Move to next line
		exception
			when Data_Error | Constraint_Error =>
			Skip_Line; -- Skip any remaining characters on line
			Put("Error: Invalid number");
	end Read_Responses;

	procedure Get_Cand(J: in Integer) is
	-- Read a single character, store it in a record, then read
	-- a list of responses and store them in the same record.
		Char	: Character;
		Num	: Integer;
		begin
			-- Put("Enter candidate's 'name':");
			Get(Char);
			Cands(J).Cand_Name := Char;
			Skip_Line; -- Move to next line
			-- Put("Enter candidate's responses:");
			for K in ResponseArray_Index loop
				Get(Num);
				Cands(J).Responses(K) := Num;
			end loop;
			Skip_Line; -- Move to next line
	end Get_Cand;

	procedure Get_All_Cands is
	-- Use Get_Cand to fill the records of all the candidates
	-- Could probably contain Get_Cand, but for now I just want
	-- the program to be functional.
		begin
			for L in 1..NumCands loop
				Get_Cand(L);
			end loop;
		end Get_All_Cands;

	procedure Score_Cands is
	-- From the RecordArray, which by now no doubt contains an array
	-- containing records of the form [ Cand_name | Responses ]
	-- determine which candidate(s) earned the higest response score
	-- According to the following criteria:
	-- 	Each value that has a 0 for either voter or cand is ignored
	-- 	Each value that is the same for voter and cand earns +1 
	-- 	Each value that is different for voter and cand nets -1
	
		procedure Score_One_Cand(CandNum: in Integer) is
		Score	: Integer := 0;
		begin
			for M in ResponseArray_Index loop
				if Voter(M) = 0 or
					Cands(CandNum).Responses(M) = 0 then
					Score := Score; -- I know this is pointless
				elsif Voter(M) = Cands(CandNum).Responses(M) then
					Score := Score + 1;
				else
					Score := Score - 1;
				end if;
			end loop;
			Scores(CandNum) := Score;
		end Score_One_Cand;

	begin
		for N in 1..NumCands loop
			Score_One_Cand(N);
		end loop;
	end Score_Cands;

	procedure Highest_Score is
	-- Finds the highest score from the list of candidates' scores
	begin
		for O in 1..NumCands loop
			if Scores(O) > Highest then
				Highest := Scores(O);
			end if;
		end loop;
	end Highest_Score;

	procedure Best_Candidates is
	-- Compares the Highest score to each individual candidate's score
	-- Prints the candidates whose scores match the highest score.
	begin
		for P in 1..NumCands loop
			if Scores(P) = Highest then
				Put(Cands(P).Cand_Name);
				New_Line; -- Add a new line
			end if;
		end loop;
	end Best_Candidates;
begin
	-- Request voter's responses:
	Read_Responses;
	-- Request number of candidates:
	Get(NumCands);
	Skip_Line;
	-- Request candidates' responses:
	Get_All_Cands;
	-- Store Scores for all Cands
	Score_Cands;
	-- Determine the highest score
	Highest_Score;
	-- Print the Best_Candidates
	Best_Candidates;
end AdaAssignment;
