
(wheel ?who)

; wheelはこれ。
; (rule (wheel ?person)
;       (and (supervisor ?middle-manager ?person)
;            (supervisor ?x ?middle-manager)))

; わからん…
; ruleの中だけ単体で動かしてみる
(and (supervisor ?middle-manager ?person)
	 (supervisor ?x ?middle-manager))

; ;;; Query results:
; (and (supervisor (Scrooge Eben) (Warbucks Oliver)) (supervisor (Cratchet Robert) (Scrooge Eben)))
; (and (supervisor (Bitdiddle Ben) (Warbucks Oliver)) (supervisor (Tweakit Lem E) (Bitdiddle Ben)))
; (and (supervisor (Hacker Alyssa P) (Bitdiddle Ben)) (supervisor (Reasoner Louis) (Hacker Alyssa P)))
; (and (supervisor (Bitdiddle Ben) (Warbucks Oliver)) (supervisor (Fect Cy D) (Bitdiddle Ben)))
; (and (supervisor (Bitdiddle Ben) (Warbucks Oliver)) (supervisor (Hacker Alyssa P) (Bitdiddle Ben)))

; あっ、なるほど。
; 4パターンあるから、という感じなんですかね。
