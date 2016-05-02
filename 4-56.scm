
(and (supervisor ?person (Bitdiddle Ben))
	 (address ?person ?address))

(and (salary (Bitdiddle Ben) ?ben-salary)
     (salary ?person ?salary)
	 (lisp-value < ?salary ?ben-salary))

(and
  (supervisor ?person ?supervisor)
  (not (job ?supervisor (computer . ?type)))
  (job ?supervisor ?job))
; notの部分を最初にもってくると結果が空になった。
; よくわからん…

