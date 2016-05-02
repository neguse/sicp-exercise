(assert! (rule (big-shot ?person ?division)
			   (and
				 (job ?person (?division . ?type))
				 (not
				   (and
					 (job ?supervisor (?division-2 . ?type-2))
					 (supervisor ?person ?supervisor)
					 (same ?division ?division-2))))))

(big-shot ?x ?y)

; この答えにたどり着くまでいろいろ施行してみたけど、
; 本文どおり書くのがいちばんだなあとおもいました。
