
; a. 再帰的べき乗

(controller
  (assign continue (label expt-done))

expt-loop
  (test (op =) (reg n) (const 0))
  (branch (label base-case))

  (save continue)
  (save n)
  (assign n (op -) (reg n) (const 1))
  (assign continue (label after-expt))

after-expt
  (restore n)
  (restore continue)
  (assign val (op *) (reg b) (reg val))
  (goto (reg continue))
base-case
  (assign val (const 1))
  (goto (reg continue))
expt-done)

; b. 反復的べき乗

(controller
  (assign p (const 1))
expt-iter
  (test (op =) (reg n) (const 0))
  (branch (label expt-done))

  (assign p (op *) (reg b) (reg p))
  (assign n (op -) (reg n) (const 1))
  (branch (label expt-iter))

expt-done)

; スタックは不要だったのだ…

