
; good-enough?とimproveが基本演算として使える版

(controller
  (assign guess (const 1.0))
sqrt-iter
  (test (op good-enough?) (reg guess))
  (branch (label sqrt-done))
  (assign guess (op improve) (reg guess))
  (goto (label sqrt-iter))
sqrt-done
  )

; good-enough?とimproveが基本演算として使えない版

(controller
  (assign guess (const 1.0))
sqrt-iter
  (assign t1 (op square) (reg guess))
  (assign t2 (op -) (reg x) (reg t1))
  (assign t3 (op abs) (reg t2))
  (test (op <) (reg t3) (const 0.001))
  (branch (label sqrt-end))
  (assign t4 (op /) (reg x) (reg guess))
  (assign guess (op avg) (reg guess) (reg t4))
  (goto (label sqrt-iter))
sqrt-done
)

