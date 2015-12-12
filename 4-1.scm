#lang racket

; これが元のやつ
(define (list-of-values exps env)
  (if (no-operands? exps)
	'()
	(cons (eval (first-operand exps) env)
		  (list-of-values (rest-operands exps) env))))

; これをconsの評価順に依存しないようにしたい
; マクロっぽいものを自分で定義すればconsを置き換えるだけでできる気がするけど、
; そうでない場合list-of-values自体をなんとかしないと

(define (list-of-values-left exps env)
  (if (no-operands? exps)
	'()
	(let ((ca (eval (first-operand exps) env)))
	  (let ((cd (list-of-values (rest-operands exps) env)))
		(cons ca cd)))))

(define (list-of-values-right exps env)
  (if (no-operands? exps)
	'()
	(let ((cd (list-of-values (rest-operands exps) env)))
	  (let ((ca (eval (first-operand exps) env)))
		(cons ca cd)))))

; こんな感じで無理やり…

