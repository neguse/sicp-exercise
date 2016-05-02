
(assert! (rule (replace ?person-1 ?person-2)
	  (and
		(job ?person-1 ?person1-job)
		(job ?person-2 ?person2-job)
		(or
		  (same ?person1-job ?person2-job)
		  (can-do-job ?person1-job ?person2-job))
		(not (same ?person-1 ?person-2)))))
; assert! しないとruleが使えなくて結果が空になるというのでだいぶ詰まった。
; 実行時エラーもコンパイルエラーもないので、つらい。

(replace ?person (Fect Cy D))

(and
  (replace ?alt ?person)
  (salary ?person ?person-salary)
  (salary ?alt ?alt-salary)
  (lisp-value < ?person-salary ?alt-salary))


