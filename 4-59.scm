
(assert! (meeting accounting (Monday 9am)))
(assert! (meeting administration (Monday 10am)))
(assert! (meeting computer (Wednesday 3pm)))
(assert! (meeting administration (Friday 1pm)))
(assert! (meeting whole-company (Wednesday 4pm)))

; (a)
(meeting ?x (Friday ?y))

; (b)
(assert! (rule (meeting-time ?person ?day-and-time)
			   (and
				 (job ?person (?division . ?type))
				 (or
				   (meeting ?division ?day-and-time)
				   (meeting whole-company ?day-and-time)))))

; (c)
(meeting-time (Hacker Alyssa P) (Wednesday . ?x))

; cは、「どの会合」って言ってるので本当はdivisionまで出したほうがいいと思うんだけど
; 同じ日時で重複してる会議あると正しい答え出せなくなるので、meeting-timeにdivision含めた方がいいと思うんだよなぁ。

