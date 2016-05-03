(assert! (rule (last-pair (?x . ()) ?x)))
(assert! (rule (last-pair (?x . ?y) ?z)
			   (last-pair ?y ?z)))

(last-pair (3) ?x)
(last-pair (1 2 3) ?x)
(last-pair (2 ?x) (3))

; (last-pair ?x (3))
; これ入れたら無限ループになった。

